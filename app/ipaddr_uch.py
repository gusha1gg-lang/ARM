"""Раздел «АБК»: /IPaddrUch.aspx, /Addipuch.aspx, /EditUch.aspx.

Логика перенесена 1-в-1 из legacy-файлов:
  IPaddrUch.aspx.cs, Addipuch.aspx.cs, EditUch.aspx.cs.

Отличия (только RBAC и безопасность) — те же, что и в предыдущих партиях
(см. MIGRATION_LOG.md, Этап 4): доступ редактора, параметризованный SQL, CSRF,
явная проверка числового поля «Этаж».
"""
from __future__ import annotations

import sqlite3

from flask import Blueprint, flash, redirect, render_template, request, url_for

from .db import get_db
from .ip_shared import find_duplicates
from .security import login_required, roles_required, validate_csrf

bp = Blueprint("ipaddr_uch", __name__)

# Поля формы в порядке оригинала (Addipuch.aspx / EditUch.aspx).
FIELDS = [
    "IDUchastok",
    "Level",
    "Kabinet",
    "ConfigLogin",
    "IPaddress",
    "CISCO",
    "MAC",
    "KE",
    "Telephon",
    "Monitor",
    "Printer",
    "UPS",
    "Modem",
    "Opisanie",
]

# Подписи — дословно из оригинальной формы.
LABELS = {
    "IDUchastok": "Название участка",
    "Level": "Этаж",
    "Kabinet": "Кабинет",
    "ConfigLogin": "Логин TS",
    "IPaddress": "IP адрес",
    "CISCO": "CISCO",
    "MAC": "MAC адрес",
    "KE": "PC/TS",
    "Telephon": "Телефон",
    "Monitor": "Монитор",
    "Printer": "Принтер",
    "UPS": "ИБП",
    "Modem": "Модем",
    "Opisanie": "Описание",
}

MULTILINE = {"Opisanie"}

# Заголовки — дословно из оригинала (в Addipuch.aspx опечатка «Добавлени данных»).
HEADING_ADD = "Добавлени данных"
HEADING_EDIT = "Редактирование данных"

# Тексты предупреждений — дословно из оригинальных валидаторов.
DUPLICATE_MESSAGE_ADD = "КЕ с таким номером уже существует, ты уверен что желаешь сохранить?"
DUPLICATE_MESSAGE_EDIT = (
    "Братюня, КЕ с таким номером уже существует, ты уверен что желаешь добавить?"
)


# --------------------------------------------------------------- справочники


def _uchastki() -> list[sqlite3.Row]:
    """Список участков — как AccessDataSource в оригинале."""
    return get_db().execute(
        'SELECT "IDUchastok", "Nameuchastka" FROM "NameUchastok" ORDER BY "Nameuchastka"'
    ).fetchall()


def _uchastok_options() -> list[tuple[str, str]]:
    return [(str(row["IDUchastok"]), row["Nameuchastka"] or "") for row in _uchastki()]


# ------------------------------------------------------------------ главная


@bp.route("/IPaddrUch.aspx")
@login_required
def main():
    rows_uchastki = _uchastki()
    options = [(str(r["IDUchastok"]), r["Nameuchastka"] or "") for r in rows_uchastki]

    # Значение по умолчанию — первый участок списка (как SelectedItem в ASP.NET).
    selected = (request.args.get("uchastok") or "").strip()
    if selected not in {value for value, _ in options}:
        selected = options[0][0] if options else ""
    selected_name = dict(options).get(selected, "")

    rows = []
    if selected:
        # Сортировка — как в оригинале: ORDER BY 4, Kabinet (4-я колонка = Level).
        rows = get_db().execute(
            'SELECT * FROM "IPAddressUch" WHERE "IDUchastok" = ? '
            'ORDER BY "Level", "Kabinet"',
            (int(selected),),
        ).fetchall()

    # Заголовок участка выводился в оригинале только внутри цикла по строкам,
    # поэтому при отсутствии записей его не было.
    groups: list[dict] = []
    if rows:
        groups.append({"type": "uchastok", "title": f"Участок: {selected_name}"})
        for counter, row in enumerate(rows, start=1):
            # Чередование цветов — как в IPaddrUch.aspx.cs (i % 2).
            groups.append(
                {
                    "type": "row",
                    "row": row,
                    "parity": "row-odd" if counter % 2 else "row-even",
                }
            )

    return render_template(
        "ipaddr_uch.html",
        groups=groups,
        options=options,
        selected=selected,
        total=len(rows),
    )


# ------------------------------------------------------------------ формы


def _row_to_data(row: sqlite3.Row) -> dict:
    return {field: ("" if row[field] is None else str(row[field])) for field in FIELDS}


def _form_data() -> dict:
    return {field: (request.form.get(field) or "") for field in FIELDS}


def _collect_warnings(data: dict, exclude_id: int | None, ke_message: str) -> dict:
    warnings = {}
    if find_duplicates("KE", data.get("KE") or "", exclude_id):
        warnings["KE"] = ke_message
    for field in ("Monitor", "Printer"):
        if find_duplicates(field, data.get(field) or "", exclude_id):
            warnings[field] = ke_message
    return warnings


def _validate(data: dict) -> str | None:
    """Проверки, которые в оригинале приводили к ошибке ODBC/FormatException."""
    if (data.get("IDUchastok") or "").strip() not in {
        value for value, _ in _uchastok_options()
    }:
        return "Выберите участок из списка."
    level = (data.get("Level") or "").strip()
    if not level:
        return "Требуется этаж"
    try:
        int(level)
    except ValueError:
        return "Этаж должен быть числом"
    return None


def _values(data: dict) -> list:
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        if field in ("IDUchastok", "Level"):
            values.append(int(value))
        else:
            values.append(value)
    return values


def _insert(db, data: dict) -> None:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    db.execute(
        f'INSERT INTO "IPAddressUch" ({columns}) VALUES ({placeholders})', _values(data)
    )
    db.commit()


def _update(db, row_id: int, data: dict) -> None:
    assignments = ", ".join(f'"{f}" = ?' for f in FIELDS)
    values = _values(data)
    values.append(row_id)
    db.execute(f'UPDATE "IPAddressUch" SET {assignments} WHERE "IDPC" = ?', values)
    db.commit()


def _render_form(
    mode: str,
    data: dict,
    warnings: dict,
    error,
    heading: str,
    row_id: int | None = None,
):
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
        selects={"IDUchastok": _uchastok_options()},
        autofocus="Level",
        form_action=(
            url_for("ipaddr_uch.add") if mode == "add"
            else url_for("ipaddr_uch.edit", id=row_id)
        ),
        back_url=url_for("ipaddr_uch.main"),
    )


# ---------------------------------------------------------------- добавить


@bp.route("/Addipuch.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def add():
    options = _uchastok_options()
    # Первый участок выбран по умолчанию — как у DropDownList в оригинале.
    data = {field: "" for field in FIELDS}
    data["IDUchastok"] = options[0][0] if options else ""
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()
        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate(data)
        if error is None:
            warnings = _collect_warnings(data, None, DUPLICATE_MESSAGE_ADD)
            if not warnings or force:
                _insert(get_db(), data)
                flash("Запись добавлена.", "success")
                return redirect(url_for("ipaddr_uch.main"))

    return _render_form("add", data, warnings, error, HEADING_ADD)


# ------------------------------------------------------------ редактировать


@bp.route("/EditUch.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def edit():
    try:
        row_id = int(request.args.get("id", ""))
    except (TypeError, ValueError):
        return render_template("error.html", code=404,
                               message="Запись не найдена."), 404

    db = get_db()
    row = db.execute(
        'SELECT * FROM "IPAddressUch" WHERE "IDPC" = ?', (row_id,)
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
            db.execute('DELETE FROM "IPAddressUch" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr_uch.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate(data)
        if error is None:
            warnings = _collect_warnings(data, row_id, DUPLICATE_MESSAGE_EDIT)
            if not warnings or force:
                _update(db, row_id, data)
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr_uch.main"))

    return _render_form("edit", data, warnings, error, HEADING_EDIT, row_id)
