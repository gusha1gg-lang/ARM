"""Раздел «Все цеха»: /IPaddrALL.aspx, /AddipALL.aspx, /EditALL.aspx.

Логика перенесена 1-в-1 из legacy-файлов:
  IPaddrALL.aspx.cs, AddipALL.aspx.cs, EditALL.aspx.cs.

Отличия (только RBAC и безопасность) — те же, что и в предыдущих партиях
(см. MIGRATION_LOG.md, Этап 4): доступ редактора, параметризованный SQL, CSRF,
явная проверка числовых полей.
"""
from __future__ import annotations

import sqlite3

from flask import Blueprint, flash, redirect, render_template, request, url_for

from .db import get_db
from .ip_shared import find_duplicates
from .security import login_required, roles_required, validate_csrf

bp = Blueprint("ipaddr_all", __name__)

# Поля формы в порядке оригинала (AddipALL.aspx / EditALL.aspx).
FIELDS = [
    "ShopID",
    "Prolet",
    "Uchastok",
    "AgeregatName",
    "Oc",
    "ConfigLogin",
    "IPaddress",
    "Shluz",
    "MAC",
    "KE",
    "Telephon",
    "Monitor",
    "Printer",
    "UPS",
    "Modem",
    "CISCO",
    "Opisanie",
]

# Подписи — дословно из оригинальной формы.
LABELS = {
    "ShopID": "Цех",
    "Prolet": "Номер пролета",
    "Uchastok": "Название участка",
    "AgeregatName": "Номер площадки",
    "Oc": "Ось",
    "ConfigLogin": "Номер пл.  или логин TS",
    "IPaddress": "IP адрес",
    "Shluz": "Основной шлюз",
    "MAC": "MAC адрес",
    "KE": "PC/TS",
    "Telephon": "Телефон",
    "Monitor": "Монитор",
    "Printer": "Принтер",
    "UPS": "ИБП",
    "Modem": "Модем",
    "CISCO": "CISCO",
    "Opisanie": "Описание",
}

MULTILINE = {"Opisanie"}

# Текст предупреждения — дословно из оригинальных валидаторов.
DUPLICATE_MESSAGE = "КЕ с таким номером уже существует, ты уверен что желаешь сохранить?"

# Пункт «все» в списке пролётов (добавлялся в конец списка).
PROLET_ALL = ("-100", "все")


# --------------------------------------------------------------- справочники


def _shops() -> list[tuple[str, str]]:
    rows = get_db().execute(
        'SELECT "ShopID", "ShopName" FROM "NameShop" ORDER BY "ShopName"'
    ).fetchall()
    return [(str(r["ShopID"]), r["ShopName"] or "") for r in rows]


def _prolets(shop_id: int) -> list[tuple[str, str]]:
    """Пролёты выбранного цеха — как AccessDataSource2 в оригинале."""
    rows = get_db().execute(
        'SELECT DISTINCT "Prolet" FROM "IPaddressAll" WHERE "ShopID" = ? ORDER BY "Prolet"',
        (shop_id,),
    ).fetchall()
    options = [(str(r["Prolet"]), str(r["Prolet"])) for r in rows]
    options.append(PROLET_ALL)
    return options


# ------------------------------------------------------------------ главная


@bp.route("/IPaddrALL.aspx")
@login_required
def main():
    shops = _shops()

    # Цех по умолчанию — первый по алфавиту (SelectedIndex = 0).
    shop_raw = (request.args.get("shop") or "").strip()
    if shop_raw not in {value for value, _ in shops}:
        shop_raw = shops[0][0] if shops else ""
    shop_id = int(shop_raw) if shop_raw else 0

    prolets = _prolets(shop_id)
    # Пролет по умолчанию — «все» (SelectedValue = "-100").
    prolet_raw = (request.args.get("prolet") or "").strip()
    if prolet_raw not in {value for value, _ in prolets}:
        prolet_raw = PROLET_ALL[0]

    sql = 'SELECT * FROM "IPaddressAll" WHERE "ShopID" = ?'
    params: list = [shop_id]
    if prolet_raw != PROLET_ALL[0]:
        sql += ' AND "Prolet" = ?'
        params.append(int(prolet_raw))
    # Порядок сортировки — как в оригинале.
    sql += ' ORDER BY "Prolet", "Oc", "Uchastok", "AgeregatName"'

    rows = get_db().execute(sql, params).fetchall()

    # Группировка «Пролет №: …» и названием участка — как в IPaddrALL.aspx.cs
    # (сравнение участка сквозным образом, начальные значения из оригинала).
    groups: list[dict] = []
    last_prolet = "-100"
    last_uchastok = "0"
    counter = 0
    for row in rows:
        prolet = "" if row["Prolet"] is None else str(row["Prolet"])
        uchastok = "" if row["Uchastok"] is None else str(row["Uchastok"])
        if prolet != last_prolet:
            last_prolet = prolet
            groups.append({"type": "prolet", "title": f"Пролет №: {prolet}"})
        if uchastok != last_uchastok:
            last_uchastok = uchastok
            groups.append({"type": "uchastok", "title": uchastok})
        counter += 1
        groups.append(
            {
                "type": "row",
                "row": row,
                "parity": "row-odd" if counter % 2 else "row-even",
            }
        )

    return render_template(
        "ipaddr_all.html",
        groups=groups,
        shops=shops,
        prolets=prolets,
        selected_shop=shop_raw,
        selected_prolet=prolet_raw,
        total=len(rows),
    )


# ------------------------------------------------------- проверка дубликатов


def _collect_warnings(data: dict, exclude_id: int | None) -> dict:
    warnings = {}
    for field in ("KE", "Monitor", "Printer"):
        if find_duplicates(field, data.get(field) or "", exclude_id):
            warnings[field] = DUPLICATE_MESSAGE
    return warnings


def _validate_numbers(data: dict) -> str | None:
    """RequiredFieldValidator + RangeValidator полей «Номер пролета» и «Ось»."""
    for field, empty_message, range_message in (
        ("Prolet", "Требуется номер пролета", "Номером пролета должно быть число"),
        ("Oc", "Недопустимый формат данных", "Введите число, чтобы указать ось"),
    ):
        value = (data.get(field) or "").strip()
        if not value:
            return empty_message
        try:
            number = int(value)
        except ValueError:
            return range_message
        if not 0 <= number <= 10000:
            return range_message
    return None


def _row_to_data(row: sqlite3.Row) -> dict:
    return {field: ("" if row[field] is None else str(row[field])) for field in FIELDS}


def _form_data() -> dict:
    return {field: (request.form.get(field) or "") for field in FIELDS}


def _values(data: dict) -> list:
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        if field in ("ShopID", "Prolet", "Oc"):
            values.append(int(value))
        else:
            values.append(value)
    return values


def _insert(db, data: dict) -> None:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    db.execute(
        f'INSERT INTO "IPaddressAll" ({columns}) VALUES ({placeholders})', _values(data)
    )
    db.commit()


def _update(db, row_id: int, data: dict) -> None:
    assignments = ", ".join(f'"{f}" = ?' for f in FIELDS)
    values = _values(data)
    values.append(row_id)
    db.execute(f'UPDATE "IPaddressAll" SET {assignments} WHERE "IDPC" = ?', values)
    db.commit()


def _empty_data() -> dict:
    data = {field: "" for field in FIELDS}
    shops = _shops()
    data["ShopID"] = shops[0][0] if shops else ""
    return data


def _render_form(
    mode: str,
    data: dict,
    warnings: dict,
    error,
    row_id: int | None = None,
):
    heading = "Добавление данных" if mode == "add" else "Редактирование данных"
    return render_template(
        "ip_form.html",
        mode=mode,
        row_id=row_id,
        heading=heading,
        data=data,
        warnings=warnings,
        error=error,
        show_force=bool(warnings),
        labels=LABELS,
        multiline=MULTILINE,
        selects={"ShopID": _shops()},
        autofocus="Prolet",
        form_action=(
            url_for("ipaddr_all.add") if mode == "add"
            else url_for("ipaddr_all.edit", id=row_id)
        ),
        back_url=url_for("ipaddr_all.main"),
    )


# ---------------------------------------------------------------- добавить


@bp.route("/AddipALL.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def add():
    data = _empty_data()
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()
        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate_numbers(data)
        if error is None:
            warnings = _collect_warnings(data, None)
            if not warnings or force:
                _insert(get_db(), data)
                # В оригинале после сохранения страница не перезагружалась:
                # форма очищалась (ClearTextBox), пользователь оставался на ней.
                flash("Запись добавлена.", "success")
                return _render_form("add", _empty_data(), {}, None)

    return _render_form("add", data, warnings, error)


# ------------------------------------------------------------ редактировать


@bp.route("/EditALL.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def edit():
    try:
        row_id = int(request.args.get("id", ""))
    except (TypeError, ValueError):
        return render_template("error.html", code=404,
                               message="Запись не найдена."), 404

    db = get_db()
    row = db.execute(
        'SELECT * FROM "IPaddressAll" WHERE "IDPC" = ?', (row_id,)
    ).fetchone()
    if row is None:
        return render_template("error.html", code=404,
                               message="Запись не найдена."), 404

    data = _row_to_data(row)
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()

        if request.form.get("action") == "delete":
            db.execute('DELETE FROM "IPaddressAll" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr_all.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate_numbers(data)
        if error is None:
            warnings = _collect_warnings(data, row_id)
            if not warnings or force:
                _update(db, row_id, data)
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr_all.main"))

    return _render_form("edit", data, warnings, error, row_id)
