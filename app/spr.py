"""Справочники: /SPR_CISCO.aspx?SPRType=1|2 и /spr_shop.aspx.

Логика перенесена 1-в-1 из legacy-файлов SPR_CISCO.aspx(.cs), spr_shop.aspx(.cs):
  * SPRType=1 — «Справочник CISCO» (таблица SPR_CISCO, ORDER BY IP_CISCO);
  * любое другое значение SPRType (и отсутствие параметра) — «Справочник камер»
    (таблица SPR_CAMERA, ORDER BY Camera_Type);
  * /spr_shop.aspx — «Справочник цехов» (таблица NameShop, ORDER BY ShopName DESC).

Отличия (осознанные, см. MIGRATION_LOG.md):
  * добавление/изменение/удаление доступны editor и admin
    (в spr_shop.aspx ограничение по Session["admin"] было закомментировано —
    править мог любой вошедший, включая viewer);
  * параметризованный SQL, CSRF-токены;
  * POST → redirect (PRG), подтверждение удаления.
"""
from __future__ import annotations

from flask import (
    Blueprint,
    abort,
    flash,
    g,
    redirect,
    render_template,
    request,
    url_for,
)

from .db import get_db
from .security import login_required, validate_csrf

bp = Blueprint("spr", __name__)

CAMERA_TYPES = ("IP", "Analog")

# Тексты валидаторов оригинала (RangeValidator + ValidationSummary).
PROLET_INT_ERROR = "Номером пролета должно быть числом"
OC_INT_ERROR = "Номером пролета должно быть число"
NUMBER_ERROR = "Введите число"
CAMERA_NAME_ERROR = "Введи марку камеры"


def _can_edit() -> bool:
    return g.user is not None and g.user["role"] in ("editor", "admin")


def _require_editor() -> None:
    if g.user is None:
        abort(401)
    if not _can_edit():
        abort(403)


def _int_or_none(value: str) -> int | None:
    value = (value or "").strip()
    if value == "":
        return None
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def _int_arg(value: str | None) -> int | None:
    try:
        return int(str(value).strip())
    except (TypeError, ValueError):
        return None


def _text(name: str) -> str:
    return (request.form.get(name) or "").strip()


# --------------------------------------------------------------- SPR_CISCO


def _cisco_rows() -> list:
    # Оригинал: SELECT * FROM [SPR_CISCO] ORDER BY [IP_CISCO]
    return get_db().execute(
        'SELECT "ID_CISCO", "IP_CISCO", "Prolet_CISCO", "Oc_CISCO", '
        '"Location_CISCO", "Opisanie_CISCO" FROM "SPR_CISCO" ORDER BY "IP_CISCO"'
    ).fetchall()


def _camera_rows() -> list:
    # Оригинал: SELECT * FROM [SPR_CAMERA] ORDER BY [Camera_Type]
    return get_db().execute(
        'SELECT "IDCAM_NAME", "Camera_Type", "Camera_Name" FROM "SPR_CAMERA" '
        'ORDER BY "Camera_Type"'
    ).fetchall()


def _cisco_insert() -> tuple[str | None, list[str]]:
    """Проверки ImgBtnInsert_Click: пусто/пусто — допустимо, иначе оба числа."""
    errors: list[str] = []
    raw_prolet = _text("Prolet_CISCO")
    raw_oc = _text("Oc_CISCO")

    prolet = _int_or_none(raw_prolet)
    oc = _int_or_none(raw_oc)

    if raw_prolet != "" and prolet is None:
        errors.append(f"{PROLET_INT_ERROR}: {NUMBER_ERROR}")
    elif prolet is not None and not -1000 <= prolet <= 1000:
        errors.append(f"{PROLET_INT_ERROR}: {NUMBER_ERROR}")

    if raw_oc != "" and oc is None:
        errors.append(f"{OC_INT_ERROR}: {NUMBER_ERROR}")
    elif oc is not None and not -1000 <= oc <= 1000:
        errors.append(f"{OC_INT_ERROR}: {NUMBER_ERROR}")

    if errors:
        return None, errors

    # Оригинал: значения вставляются только когда заполнены оба поля или ни одного.
    if (raw_prolet == "") != (raw_oc == ""):
        return None, [
            "Заполни оба поля «Пролет» и «Ось» или оставь их пустыми"
        ]

    return f"cisco:{prolet}:{oc}", []


def _parse_cisco_token(token: str) -> tuple[int | None, int | None]:
    _, prolet, oc = token.split(":")
    return (int(prolet) if prolet != "None" else None,
            int(oc) if oc != "None" else None)


# ------------------------------------------------------------------- routes


@bp.route("/SPR_CISCO.aspx", methods=("GET", "POST"))
@login_required
def spr_cisco():
    spr_type = request.args.get("SPRType")
    mode = "cisco" if spr_type == "1" else "camera"
    can_edit = _can_edit()

    if request.method == "POST":
        if not can_edit:
            abort(403)
        validate_csrf()
        action = request.form.get("action")

        if mode == "cisco":
            db = get_db()
            if action == "insert":
                token, errors = _cisco_insert()
                if errors:
                    for error in errors:
                        flash(error, "error")
                else:
                    prolet, oc = _parse_cisco_token(token)
                    db.execute(
                        'INSERT INTO "SPR_CISCO" ("IP_CISCO", "Prolet_CISCO", "Oc_CISCO", '
                        '"Location_CISCO", "Opisanie_CISCO") VALUES (?, ?, ?, ?, ?)',
                        (
                            _text("IP_CISCO"),
                            prolet,
                            oc,
                            _text("Location_CISCO"),
                            _text("Opisanie_CISCO"),
                        ),
                    )
                    db.commit()
                    flash("Запись добавлена.", "success")
                return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

            row_id = _int_arg(request.form.get("id"))
            if row_id is None:
                abort(400)

            if action == "delete":
                db.execute('DELETE FROM "SPR_CISCO" WHERE "ID_CISCO" = ?', (row_id,))
                db.commit()
                flash(f"Запись №{row_id} удалена.", "success")
                return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

            if action == "update":
                db.execute(
                    'UPDATE "SPR_CISCO" SET "IP_CISCO" = ?, "Prolet_CISCO" = ?, '
                    '"Oc_CISCO" = ?, "Location_CISCO" = ?, "Opisanie_CISCO" = ? '
                    'WHERE "ID_CISCO" = ?',
                    (
                        _text("IP_CISCO"),
                        _int_or_none(_text("Prolet_CISCO")),
                        _int_or_none(_text("Oc_CISCO")),
                        _text("Location_CISCO"),
                        _text("Opisanie_CISCO"),
                        row_id,
                    ),
                )
                db.commit()
                flash("Изменения сохранены.", "success")
                return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

            abort(400)

        # ---- справочник камер
        db = get_db()
        if action == "insert":
            camera_name = _text("Camera_Name")
            camera_type = _text("Camera_Type")
            if not camera_name:
                flash(CAMERA_NAME_ERROR, "error")
            elif camera_type not in CAMERA_TYPES:
                flash("Тип камеры должен быть IP или Analog", "error")
            else:
                db.execute(
                    'INSERT INTO "SPR_CAMERA" ("Camera_Type", "Camera_Name") VALUES (?, ?)',
                    (camera_type, camera_name),
                )
                db.commit()
                flash("Запись добавлена.", "success")
            return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

        row_id = _int_arg(request.form.get("id"))
        if row_id is None:
            abort(400)

        if action == "delete":
            db.execute('DELETE FROM "SPR_CAMERA" WHERE "IDCAM_NAME" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

        if action == "update":
            camera_type = _text("Camera_Type")
            if camera_type not in CAMERA_TYPES:
                flash("Тип камеры должен быть IP или Analog", "error")
                return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))
            db.execute(
                'UPDATE "SPR_CAMERA" SET "Camera_Type" = ?, "Camera_Name" = ? '
                'WHERE "IDCAM_NAME" = ?',
                (camera_type, _text("Camera_Name"), row_id),
            )
            db.commit()
            flash("Изменения сохранены.", "success")
            return redirect(url_for("spr.spr_cisco", SPRType=spr_type or ""))

        abort(400)

    rows = _cisco_rows() if mode == "cisco" else _camera_rows()
    edit_id = _int_arg(request.args.get("edit"))
    key = "ID_CISCO" if mode == "cisco" else "IDCAM_NAME"
    edit_row = next((r for r in rows if r[key] == edit_id), None) if can_edit else None

    return render_template(
        "spr_cisco.html",
        mode=mode,
        title="Справочник CISCO" if mode == "cisco" else "Справочник камер",
        spr_type=spr_type or "",
        rows=rows,
        can_edit=can_edit,
        edit_id=edit_id,
        edit_row=edit_row,
        camera_types=CAMERA_TYPES,
        total=len(rows),
    )


# ---------------------------------------------------------------- spr_shop


def _shop_rows(sort: str | None, direction: str) -> list:
    # Оригинал: SELECT * FROM [NameShop] ORDER BY [ShopName] DESC
    order = "DESC"
    column = "ShopName"
    if sort == "ShopID":
        column = "ShopID"
    elif sort == "ShopName":
        column = "ShopName"
    if direction == "asc":
        order = "ASC"
    return get_db().execute(
        f'SELECT "ShopID", "ShopName" FROM "NameShop" ORDER BY "{column}" {order}'
    ).fetchall()


@bp.route("/spr_shop.aspx", methods=("GET", "POST"))
@login_required
def spr_shop():
    can_edit = _can_edit()

    sort = request.args.get("sort")
    if sort not in (None, "ShopID", "ShopName"):
        sort = None
    direction = "asc" if request.args.get("dir") == "asc" else "desc"
    # По умолчанию — как в оригинале: ORDER BY ShopName DESC.
    if sort is None:
        direction = "desc"

    if request.method == "POST":
        if not can_edit:
            abort(403)
        validate_csrf()
        action = request.form.get("action")
        db = get_db()

        if action == "insert":
            # Оригинал: INSERT INTO [NameShop] ([ShopName]) VALUES (?)
            db.execute(
                'INSERT INTO "NameShop" ("ShopName") VALUES (?)', (_text("ShopName"),)
            )
            db.commit()
            flash("Запись добавлена.", "success")
            return redirect(url_for("spr.spr_shop", sort=sort, dir=direction))

        row_id = _int_arg(request.form.get("id"))
        if row_id is None:
            abort(400)

        if action == "delete":
            db.execute('DELETE FROM "NameShop" WHERE "ShopID" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("spr.spr_shop", sort=sort, dir=direction))

        if action == "update":
            db.execute(
                'UPDATE "NameShop" SET "ShopName" = ? WHERE "ShopID" = ?',
                (_text("ShopName"), row_id),
            )
            db.commit()
            flash("Изменения сохранены.", "success")
            return redirect(url_for("spr.spr_shop", sort=sort, dir=direction))

        abort(400)

    rows = _shop_rows(sort, direction)
    edit_id = _int_arg(request.args.get("edit"))
    edit_row = next((r for r in rows if r["ShopID"] == edit_id), None) if can_edit else None

    return render_template(
        "spr_shop.html",
        rows=rows,
        can_edit=can_edit,
        edit_id=edit_id,
        edit_row=edit_row,
        sort=sort,
        direction=direction,
        total=len(rows),
    )
