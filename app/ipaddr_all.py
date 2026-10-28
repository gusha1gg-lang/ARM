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

from .audit import last_change, log_action
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

#: Нижняя граница «Номера пролета» — пролёт -1 есть в справочнике NameProlet.
PROLET_MIN = -1000

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


def _validate_numbers(data: dict) -> tuple[str | None, str | None]:
    """RequiredFieldValidator + RangeValidator полей «Номер пролета» и «Ось».

    Возвращает пару (блокирующая_ошибка, ошибка_диапазона): ошибку диапазона
    можно обойти кнопкой «Все равно сохранить», как Button2 в оригинале.
    Нижняя граница пролёта — -1000, т.к. в NameProlet есть пролёт -1.
    """
    for field, empty_message, range_message in (
        ("Prolet", "Требуется номер пролета", "Номером пролета должно быть число"),
        ("Oc", "Недопустимый формат данных", "Введите число, чтобы указать ось"),
    ):
        value = (data.get(field) or "").strip()
        if not value:
            return empty_message, None
        try:
            number = int(value)
        except ValueError:
            return range_message, None
        low = PROLET_MIN if field == "Prolet" else 0
        if not low <= number <= 10000:
            return None, range_message
    return None, None


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


def _log_details(data: dict) -> str:
    """Краткое описание записи для журнала действий."""
    return (
        f"цех №{data.get('ShopID') or '—'}, "
        f"пролет {data.get('Prolet') or '—'}, "
        f"ось {data.get('Oc') or '—'}, "
        f"КЕ {data.get('KE') or '—'}, "
        f"IP {data.get('IPaddress') or '—'}"
    )


def _insert(db, data: dict) -> int:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    cursor = db.execute(
        f'INSERT INTO "IPaddressAll" ({columns}) VALUES ({placeholders})', _values(data)
    )
    db.commit()
    return cursor.lastrowid


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
    last_change_info=None,
    show_force: bool | None = None,
):
    heading = "Добавление данных" if mode == "add" else "Редактирование данных"
    if show_force is None:
        show_force = bool(warnings)
    return render_template(
        "ip_form.html",
        mode=mode,
        row_id=row_id,
        heading=heading,
        data=data,
        warnings=warnings,
        error=error,
        show_force=show_force,
        labels=LABELS,
        multiline=MULTILINE,
        selects={"ShopID": _shops()},
        autofocus="Prolet",
        form_action=(
            url_for("ipaddr_all.add") if mode == "add"
            else url_for("ipaddr_all.edit", id=row_id)
        ),
        back_url=url_for("ipaddr_all.main"),
        last_change_info=last_change_info,
    )


# ---------------------------------------------------------------- добавить


@bp.route("/AddipALL.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def add():
    data = _empty_data()
    warnings: dict = {}
    error = None
    show_force = False

    if request.method == "POST":
        validate_csrf()
        data = _form_data()
        force = request.form.get("force") == "1"

        blocking, range_error = _validate_numbers(data)
        if blocking is not None:
            error = blocking
        else:
            warnings = _collect_warnings(data, None)
            if force or (range_error is None and not warnings):
                new_id = _insert(get_db(), data)
                log_action("create", "IPaddressAll", new_id, _log_details(data))
                # В оригинале после сохранения страница не перезагружалась:
                # форма очищалась (ClearTextBox), пользователь оставался на ней.
                flash("Запись добавлена.", "success")
                return _render_form("add", _empty_data(), {}, None)
            error = range_error
            show_force = True

    return _render_form("add", data, warnings, error,
                        show_force=show_force)


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
    show_force = False

    if request.method == "POST":
        validate_csrf()

        if request.form.get("action") == "delete":
            db.execute('DELETE FROM "IPaddressAll" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            log_action("delete", "IPaddressAll", row_id,
                       _log_details(_row_to_data(row)))
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr_all.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        blocking, range_error = _validate_numbers(data)
        if blocking is not None:
            error = blocking
        else:
            warnings = _collect_warnings(data, row_id)
            if force or (range_error is None and not warnings):
                _update(db, row_id, data)
                log_action("update", "IPaddressAll", row_id, _log_details(data))
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr_all.main"))
            error = range_error
            show_force = True

    return _render_form("edit", data, warnings, error, row_id,
                        last_change("IPaddressAll", row_id),
                        show_force=show_force)
