"""Раздел «Видеонаблюдение»: /VideoIP.aspx?VideoType=IP|Analog.

Логика перенесена 1-в-1 из legacy-файлов:
  VideoIP.aspx, VideoIP.aspx.cs, App_Code/VideoCameraDataAccesseLayer.cs,
  App_Code/SPR_Camera_DataAccesseLayer.cs, App_Code/SPR_Prolet_DAL.cs.

Одна страница обслуживает два вида камер (Camera_Type = IP / Analog) с разным
набором колонок — как два GridView в оригинале.

Отличия (осознанные, см. MIGRATION_LOG.md):
  * редактирование/добавление/удаление/загрузка доступны editor и admin
    (в оригинале — только admin по Session["admin"]);
  * параметризованный SQL, CSRF-токены;
  * вместо падения при ShopID=8 (его нет в NameShop) выбирается первый цех;
  * при нечисловой оси показывается сообщение вместо «тихого» игнорирования;
  * POST → redirect (PRG) вместо повторной отрисовки.
"""
from __future__ import annotations

import os

from flask import (
    Blueprint,
    abort,
    flash,
    g,
    jsonify,
    redirect,
    render_template,
    request,
    send_from_directory,
    url_for,
)

from .config import BASE_DIR
from .db import get_db
from .security import login_required, roles_required, validate_csrf

bp = Blueprint("video", __name__)

VIDEO_TYPES = {
    "IP": "IP видеонаблюдение",
    "Analog": "Аналоговое видеонаблюдение",
}

# Каталог загрузок оригинального сайта: в БД уже лежат значения uploads/<файл>.
UPLOAD_DIR = BASE_DIR / "uploads"

ALLOWED_EXTENSIONS = (".png", ".jpeg", ".jpg", ".gif")
MAX_UPLOAD_SIZE = 4 * 1024 * 1024

# Поля вставки — порядок/набор из InsertVideoCamera (VideoCameraDataAccesseLayer).
INSERT_FIELDS = [
    "IDCAM_NAME",
    "Oc",
    "Prolet",
    "ShopID",
    "Uchastok",
    "Camera_number",
    "IPaddress",
    "Login_password",
    "IP_Server_PC",
    "IP_CAMERA_STREAM",
    "Port_CISCO",
    "Video_out_lacation_PC",
    "Monitor",
    "Opisanie",
    "ID_CISCO",
    "Camera_Type",
    "upload_img",
]

# Поля обновления — из UpdateVideoCamera. CISCO в оригинале всегда сбрасывался
# в пустую строку (параметр не был привязан к полю формы); поведение сохранено.
UPDATE_FIELDS = [
    "IDCAM_NAME",
    "Oc",
    "Prolet",
    "ShopID",
    "Uchastok",
    "IPaddress",
    "Camera_number",
    "IP_Server_PC",
    "IP_CAMERA_STREAM",
    "Login_password",
    "Port_CISCO",
    "Video_out_lacation_PC",
    "Monitor",
    "Opisanie",
    "ID_CISCO",
    "upload_img",
]

NUMERIC_FIELDS = {"IDCAM_NAME", "Oc", "Prolet", "ShopID", "ID_CISCO"}

SELECT_QUERY = """
    SELECT v."ID_VID_CAM", v."IDCAM_NAME", v."Oc", v."Prolet", v."ShopID",
           v."Uchastok", v."IPaddress", v."Camera_number", v."IP_Server_PC",
           v."IP_CAMERA_STREAM", v."Login_password", v."CISCO", v."Port_CISCO",
           v."Video_out_lacation_PC", v."Monitor", v."Opisanie", v."upload_img",
           c."Camera_Name",
           k."IP_CISCO", k."Prolet_CISCO", k."Oc_CISCO",
           k."Location_CISCO", k."Opisanie_CISCO",
           s."ShopName"
      FROM "Video_Camera_all" v
      JOIN "SPR_CAMERA" c ON c."IDCAM_NAME" = v."IDCAM_NAME"
      JOIN "SPR_CISCO"  k ON k."ID_CISCO" = v."ID_CISCO"
      JOIN "NameShop"   s ON s."ShopID" = v."ShopID"
     WHERE v."ShopID" = ? AND v."Prolet" = ? AND v."Camera_Type" = ?
"""


# --------------------------------------------------------------- справочники


def _shops() -> list[tuple[str, str]]:
    rows = get_db().execute(
        'SELECT "ShopID", "ShopName" FROM "NameShop" ORDER BY "ShopName"'
    ).fetchall()
    return [(str(r["ShopID"]), r["ShopName"] or "") for r in rows]


def _prolets_for_shop(shop_id: int) -> list[tuple[str, str]]:
    """AccessDataSource2: NameProlet WHERE ShopID=? ORDER BY Prolet."""
    rows = get_db().execute(
        'SELECT "Prolet", "Prolet_name" FROM "NameProlet" '
        'WHERE "ShopID" = ? ORDER BY "Prolet"',
        (shop_id,),
    ).fetchall()
    return [(str(r["Prolet"]), r["Prolet_name"] or "") for r in rows]


def _prolets_all() -> list[tuple[str, str]]:
    """Справочник пролётов для форм (NameProlet ORDER BY Prolet)."""
    rows = get_db().execute(
        'SELECT "Prolet", "Prolet_name" FROM "NameProlet" ORDER BY "Prolet"'
    ).fetchall()
    return [(str(r["Prolet"]), r["Prolet_name"] or "") for r in rows]


def _prolets_footer() -> list[tuple[str, str]]:
    """ADS_Foot_Prolet: NameProlet WHERE Prolet<>-100 ORDER BY Prolet.

    Особенность оригинала: список не фильтруется по выбранному цеху.
    """
    rows = get_db().execute(
        'SELECT "Prolet", "Prolet_name" FROM "NameProlet" '
        'WHERE "Prolet" <> -100 ORDER BY "Prolet"'
    ).fetchall()
    return [(str(r["Prolet"]), r["Prolet_name"] or "") for r in rows]


def _cameras(camera_type: str) -> list[tuple[str, str]]:
    rows = get_db().execute(
        'SELECT "IDCAM_NAME", "Camera_Name" FROM "SPR_CAMERA" '
        'WHERE "Camera_Type" = ? ORDER BY "Camera_Name"',
        (camera_type,),
    ).fetchall()
    return [(str(r["IDCAM_NAME"]), r["Camera_Name"] or "") for r in rows]


def _ciscos() -> list[tuple[str, str]]:
    rows = get_db().execute(
        'SELECT "ID_CISCO", "IP_CISCO" FROM "SPR_CISCO"'
    ).fetchall()
    return [(str(r["ID_CISCO"]), r["IP_CISCO"] or "") for r in rows]


# ------------------------------------------------------------------ выборка


def _resolve_filters() -> tuple[str, str, int, list, list]:
    """Цех/пролет/тип и справочники для текущего запроса."""
    shops = _shops()
    shop_ids = {value for value, _ in shops}

    shop_raw = (request.args.get("shop") or "").strip()
    if shop_raw not in shop_ids:
        # Оригинал: Shop.SelectedValue = "8". Такого цеха в NameShop нет,
        # поэтому берём первый по названию цех, у которого есть справочник
        # пролётов (иначе ASP.NET падал, а страница была бы пустой).
        with_prolets = {
            str(r["ShopID"])
            for r in get_db().execute(
                'SELECT DISTINCT "ShopID" FROM "NameProlet"'
            ).fetchall()
        }
        candidates = [value for value, _ in shops if value in with_prolets]
        shop_raw = "8" if "8" in shop_ids else (
            candidates[0] if candidates else (shops[0][0] if shops else "")
        )
    shop_id = int(shop_raw) if shop_raw else 0

    prolets = _prolets_for_shop(shop_id)
    prolet_values = {value for value, _ in prolets}
    prolet_raw = (request.args.get("prolet") or "").strip()
    if prolet_raw not in prolet_values:
        # Оригинал: Prolet.SelectedIndex = 1 (второй пункт), с защитой от
        # пустого/одноэлементного списка.
        if len(prolets) > 1:
            prolet_raw = prolets[1][0]
        elif prolets:
            prolet_raw = prolets[0][0]
        else:
            prolet_raw = ""

    return shop_raw, prolet_raw, shop_id, shops, prolets


def _video_type() -> str | None:
    value = request.args.get("VideoType")
    return value if value in VIDEO_TYPES else None


def _load_rows(video_type: str, shop_id: int, prolet: int) -> list:
    return get_db().execute(
        SELECT_QUERY, (shop_id, prolet, video_type)
    ).fetchall()


# ------------------------------------------------------------------ действия


def _require_editor() -> None:
    if g.user is None:
        abort(401)
    if g.user["role"] not in ("editor", "admin"):
        abort(403)


def _redirect_back(video_type: str | None, shop: str, prolet: str):
    args = {}
    if video_type:
        args["VideoType"] = video_type
    if shop:
        args["shop"] = shop
    if prolet:
        args["prolet"] = prolet
    return redirect(url_for("video.main", **args))


def _int_field(value: str) -> int | None:
    try:
        return int(str(value).strip())
    except (TypeError, ValueError):
        return None


def _validate_oc(raw: str) -> tuple[int | None, str | None]:
    """RangeValidator -1000…1000 + TryParse из оригинала."""
    value = (raw or "").strip()
    number = _int_field(value)
    if number is None:
        return None, "Введите число"
    if not -1000 <= number <= 1000:
        return None, "Введите число"
    return number, None


def _form_values(fields: list[str]) -> dict:
    return {field: (request.form.get(field) or "").strip() for field in fields}


def _values_for_row(data: dict, fields: list[str]) -> list:
    values = []
    for field in fields:
        value = data.get(field) or ""
        if field in NUMERIC_FIELDS:
            values.append(int(value) if value != "" else 0)
        else:
            values.append(value)
    return values


# -------------------------------------------------------------------- upload


@bp.route("/uploads/<path:filename>")
@login_required
def uploaded_file(filename):
    """Отдача файлов из legacy-каталога uploads/ (значения upload_img)."""
    return send_from_directory(UPLOAD_DIR, filename)


@bp.route("/VideoIP/upload", methods=("POST",))
@roles_required("editor", "admin")
def upload():
    validate_csrf()
    file = request.files.get("file")
    if file is None or not file.filename:
        return jsonify(ok=False, message="Выбери файл для загрузки"), 400

    # В оригинале сохранялось исходное имя файла (включая кириллицу),
    # поэтому оставляем его, убирая только путь.
    name = file.filename.replace("\\", "/").split("/")[-1]
    name = name.replace("\x00", "").strip()
    if name in ("", ".", ".."):
        return jsonify(ok=False, message="Выбери файл для загрузки"), 400
    extension = os.path.splitext(name)[1].lower()
    if extension not in ALLOWED_EXTENSIONS:
        return jsonify(
            ok=False, message="Только файлы с расширением .png или .jpeg"
        ), 400

    file.stream.seek(0, os.SEEK_END)
    size = file.stream.tell()
    file.stream.seek(0)
    if size > MAX_UPLOAD_SIZE:
        return jsonify(ok=False, message="Максимальный размер файла 4Mb"), 400

    UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    file.save(str(UPLOAD_DIR / name))
    return jsonify(ok=True, message="Файл загружен", path=f"uploads/{name}")


@bp.app_errorhandler(413)
def too_large(exc):
    if request.path.startswith("/VideoIP"):
        return jsonify(ok=False, message="Максимальный размер файла 4Mb"), 413
    return "Файл слишком большой.", 413


@bp.route("/VideoAnalog.aspx")
@login_required
def analog_page():
    """Оригинальная VideoAnalog.aspx — статическая картинка (не в меню)."""
    return render_template("video_analog.html")


# ------------------------------------------------------------------ страница


@bp.route("/VideoIP.aspx", methods=("GET", "POST"))
@login_required
def main():
    video_type = _video_type()
    shop_raw, prolet_raw, shop_id, shops, prolets = _resolve_filters()

    if request.method == "POST":
        _require_editor()
        validate_csrf()
        action = request.form.get("action")

        if action == "insert" and video_type:
            data = _form_values(INSERT_FIELDS)
            data["Camera_Type"] = video_type
            oc, error = _validate_oc(data.get("Oc", ""))
            if error:
                flash(error, "error")
            else:
                data["Oc"] = str(oc)
                columns = ", ".join(f'"{f}"' for f in INSERT_FIELDS)
                placeholders = ", ".join("?" for _ in INSERT_FIELDS)
                db = get_db()
                db.execute(
                    f'INSERT INTO "Video_Camera_all" ({columns}) VALUES ({placeholders})',
                    _values_for_row(data, INSERT_FIELDS),
                )
                db.commit()
                flash("Запись добавлена.", "success")
            return _redirect_back(video_type, shop_raw, prolet_raw)

        if action in ("update", "delete"):
            row_id = _int_field(request.form.get("id", ""))
            if row_id is None:
                abort(400)
            db = get_db()
            if action == "delete":
                db.execute(
                    'DELETE FROM "Video_Camera_all" WHERE "ID_VID_CAM" = ?', (row_id,)
                )
                db.commit()
                flash(f"Запись №{row_id} удалена.", "success")
                return _redirect_back(video_type, shop_raw, prolet_raw)

            data = _form_values(UPDATE_FIELDS)
            oc, error = _validate_oc(data.get("Oc", ""))
            if error:
                flash(error, "error")
                return _redirect_back(video_type, shop_raw, prolet_raw)

            data["Oc"] = str(oc)
            assignments = ", ".join(f'"{f}" = ?' for f in UPDATE_FIELDS)
            values = _values_for_row(data, UPDATE_FIELDS)
            values.append("")  # CISCO — как в оригинале (не привязан к форме)
            values.append(row_id)
            db.execute(
                f'UPDATE "Video_Camera_all" SET {assignments}, "CISCO" = ? '
                'WHERE "ID_VID_CAM" = ?',
                values,
            )
            db.commit()
            flash("Изменения сохранены.", "success")
            return _redirect_back(video_type, shop_raw, prolet_raw)

        abort(400)

    rows: list = []
    if video_type:
        prolet_id = _int_field(prolet_raw)
        if prolet_id is not None:
            rows = _load_rows(video_type, shop_id, prolet_id)

    edit_id = _int_field((request.args.get("edit") or "").strip())
    edit_row = None
    if edit_id is not None:
        edit_row = next((r for r in rows if r["ID_VID_CAM"] == edit_id), None)

    can_edit = g.user is not None and g.user["role"] in ("editor", "admin")

    cameras = _cameras(video_type) if video_type else []
    return render_template(
        "video.html",
        video_type=video_type,
        title=VIDEO_TYPES.get(video_type, ""),
        shops=shops,
        prolets=prolets,
        selected_shop=shop_raw,
        selected_prolet=prolet_raw,
        rows=rows,
        empty_text="Данные по выбранному пролету отсутствуют",
        can_edit=can_edit,
        edit_row=edit_row,
        edit_id=edit_id,
        all_prolets=_prolets_all(),
        footer_prolets=_prolets_footer(),
        cameras=cameras,
        ciscos=_ciscos(),
    )
