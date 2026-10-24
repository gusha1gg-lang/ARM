"""Раздел «ТЭСЦ 5»: /IpaddrT5.aspx, /Addipt5.aspx, /Editipt5.aspx.

Логика перенесена 1-в-1 из legacy-файлов:
  IpaddrT5.aspx.cs, Addipt5.aspx.cs, Editipt5.aspx.cs.

Отличия (только RBAC и безопасность) — те же, что и в разделе «ТЭСК ТБД»
(см. MIGRATION_LOG.md, Этап 4): доступ редактора, параметризованный SQL, CSRF.
"""
from __future__ import annotations

import sqlite3

from flask import Blueprint, flash, redirect, render_template, request, url_for

from .db import get_db
from .ip_shared import find_duplicates
from .security import login_required, roles_required, validate_csrf

bp = Blueprint("ipaddr5", __name__)

# Поля формы в порядке оригинала (Addipt5.aspx / Editipt5.aspx).
FIELDS = [
    "Uchastok",
    "Oc",
    "IPaddress",
    "MAC",
    "KE",
    "ConfigLogin",
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
    "Uchastok": "Название участка",
    "Oc": "Ось",
    "IPaddress": "IP адрес",
    "MAC": "MAC адрес",
    "KE": "PC/TS",
    "ConfigLogin": "Логин TS",
    "Telephon": "Телефон",
    "Monitor": "Монитор",
    "Printer": "Принтер",
    "UPS": "ИБП",
    "Modem": "Модем",
    "CISCO": "CISCO",
    "Opisanie": "Описание",
}

MULTILINE = {"Opisanie"}

# Тексты предупреждений — дословно из оригинальных валидаторов.
DUPLICATE_MESSAGE = "КЕ с таким номером уже существует, ты уверен что желаешь сохранить?"
DUPLICATE_KE_ADD = (
    "Братюня, КЕ с таким номером уже существует, ты уверен что желаешь добавить?"
)


# ------------------------------------------------------------------ главная


@bp.route("/IpaddrT5.aspx")
@login_required
def main():
    # Сортировка — как в оригинале.
    rows = get_db().execute(
        'SELECT * FROM "IPaddress5" ORDER BY "Oc", "Uchastok"'
    ).fetchall()

    groups: list[dict] = []
    last_uchastok = "0"
    counter = 0
    for row in rows:
        uchastok = "" if row["Uchastok"] is None else str(row["Uchastok"])
        if uchastok != last_uchastok:
            last_uchastok = uchastok
            groups.append({"type": "uchastok", "title": uchastok})
        counter += 1
        # WhiteSmoke / White — как в IpaddrT5.aspx.cs.
        groups.append(
            {
                "type": "row",
                "row": row,
                "parity": "row-smoke" if counter % 2 else "row-white",
            }
        )

    return render_template("ipaddr5.html", groups=groups, total=len(rows))


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
            warnings[field] = DUPLICATE_MESSAGE
    return warnings


def _validate_oc(data: dict) -> str | None:
    """RequiredFieldValidator + RangeValidator для поля «Ось»."""
    value = (data.get("Oc") or "").strip()
    if not value:
        return "Неправильный формат данных"
    try:
        number = int(value)
    except ValueError:
        return "Должно быть число"
    if not 0 <= number <= 10000:
        return "Должно быть число"
    return None


def _values(data: dict) -> list:
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        values.append(int(value) if field == "Oc" else value)
    return values


def _insert(db, data: dict) -> None:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    db.execute(
        f'INSERT INTO "IPaddress5" ({columns}) VALUES ({placeholders})', _values(data)
    )
    db.commit()


def _update(db, row_id: int, data: dict) -> None:
    assignments = ", ".join(f'"{f}" = ?' for f in FIELDS)
    values = _values(data)
    values.append(row_id)
    db.execute(f'UPDATE "IPaddress5" SET {assignments} WHERE "IDPC" = ?', values)
    db.commit()


def _render_form(mode: str, data: dict, warnings: dict, error, row_id: int | None = None):
    return render_template(
        "ip_form.html",
        mode=mode,
        row_id=row_id,
        data=data,
        warnings=warnings,
        error=error,
        show_force=bool(warnings),
        labels=LABELS,
        multiline=MULTILINE,
        autofocus="Uchastok",
        form_action=(
            url_for("ipaddr5.add") if mode == "add"
            else url_for("ipaddr5.edit", id=row_id)
        ),
        back_url=url_for("ipaddr5.main"),
    )


# ---------------------------------------------------------------- добавить


@bp.route("/Addipt5.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def add():
    data = {field: "" for field in FIELDS}
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()
        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate_oc(data)
        if error is None:
            warnings = _collect_warnings(data, None, DUPLICATE_KE_ADD)
            if not warnings or force:
                _insert(get_db(), data)
                flash("Запись добавлена.", "success")
                return redirect(url_for("ipaddr5.main"))

    return _render_form("add", data, warnings, error)


# ------------------------------------------------------------ редактировать


@bp.route("/Editipt5.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def edit():
    try:
        row_id = int(request.args.get("id", ""))
    except (TypeError, ValueError):
        return render_template("error.html", code=404,
                               message="Запись не найдена."), 404

    db = get_db()
    row = db.execute('SELECT * FROM "IPaddress5" WHERE "IDPC" = ?', (row_id,)).fetchone()
    if row is None:
        return render_template("error.html", code=404,
                               message="Запись не найдена."), 404

    data = _row_to_data(row)
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()

        if request.form.get("action") == "delete":
            db.execute('DELETE FROM "IPaddress5" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr5.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate_oc(data)
        if error is None:
            warnings = _collect_warnings(data, row_id, DUPLICATE_MESSAGE)
            if not warnings or force:
                _update(db, row_id, data)
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr5.main"))

    return _render_form("edit", data, warnings, error, row_id)
