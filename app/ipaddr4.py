"""Раздел «ТЭСК ТБД»: /main.aspx, /Addipt4.aspx, /Edit.aspx, /ReportExist.aspx.

Логика перенесена 1-в-1 из legacy-файлов:
  main.aspx.cs, Addipt4.aspx.cs, Edit.aspx.cs, ReportExist.aspx.cs.

Отличия (только RBAC и безопасность), зафиксированы в MIGRATION_LOG.md:
  * кнопки «Добавить» и значок «Редактировать» видны editor и admin
    (в оригинале — только администратору);
  * SQL-параметризация вместо конкатенации строк;
  * CSRF-токены и подтверждение удаления.
"""
from __future__ import annotations

import sqlite3

from flask import (
    Blueprint,
    flash,
    redirect,
    render_template,
    request,
    url_for,
)

from .db import get_db
from .security import login_required, roles_required, validate_csrf

bp = Blueprint("ipaddr4", __name__)

# Список пролётов — дословно из main.aspx.
PROLETS = [
    ("-100", "все"),
    ("-1", "Пролет №-1 Ф-Ц"),
    ("0", "Пролет №0 У-Ф"),
    ("1", "Пролет №1 Т-У"),
    ("2", "Пролет №2 (Б-В В-Г)"),
    ("5", "Пролет №5 К'-Л"),
    ("6", "Пролет №6 Л'-П"),
    ("7", "Пролет №7 П'-Р'"),
    ("10", "Внешний участок"),
]

# Поля формы в порядке оригинала (Addipt4.aspx / Edit.aspx).
FIELDS = [
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

# Таблицы, в которых оригинал искал дубликаты.
IP_TABLES = ("IPaddress4", "IPAddressUch", "IPaddress5", "IPaddressAll")


# ------------------------------------------------------------------ главная


@bp.route("/main.aspx")
@login_required
def main():
    db = get_db()

    raw = request.args.get("prolet", "-100")
    if raw not in {value for value, _ in PROLETS}:
        raw = "-100"

    sql = 'SELECT * FROM "IPaddress4"'
    params: tuple = ()
    if raw != "-100":
        sql += ' WHERE "Prolet" = ?'
        params = (int(raw),)
    # Порядок сортировки — как в оригинале.
    sql += ' ORDER BY "Prolet", "Oc", "Uchastok", "AgeregatName"'

    rows = db.execute(sql, params).fetchall()

    # Группировка заголовками «Пролет №: …» и названием участка.
    # Поведение (включая сравнение участка сквозным образом) сохранено 1-в-1.
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
        # Чередование цветов — как в main.aspx.cs (i % 2).
        groups.append(
            {
                "type": "row",
                "row": row,
                "parity": "row-odd" if counter % 2 else "row-even",
            }
        )

    return render_template(
        "main.html",
        groups=groups,
        prolets=PROLETS,
        selected=raw,
        total=len(rows),
    )


# ------------------------------------------------------- проверка дубликатов


def _duplicates(field: str, value: str, exclude_id: int | None) -> bool:
    """Аналог CustomValidator из Addipt4.aspx.cs / Edit.aspx.cs.

    Проверяются только непустые значения (как в ASP.NET:
    ValidateEmptyText по умолчанию выключен).
    """
    if not value:
        return False

    if field == "KE":
        condition = '"KE" = ?'
        param = value
    else:
        condition = f'"{field}" LIKE ?'
        param = f"%{value}%"

    db = get_db()
    for table in IP_TABLES:
        query = f'SELECT 1 FROM "{table}" WHERE {condition}'
        args: list = [param]
        if exclude_id is not None:
            query += ' AND "IDPC" <> ?'
            args.append(exclude_id)
        if db.execute(query, args).fetchone() is not None:
            return True
    return False


def _collect_warnings(data: dict, exclude_id: int | None) -> dict:
    warnings = {}
    for field in ("KE", "Monitor", "Printer"):
        if _duplicates(field, (data.get(field) or "").strip(), exclude_id):
            warnings[field] = DUPLICATE_MESSAGE
    return warnings


def _validate_numbers(data: dict) -> str | None:
    """Проверка числовых полей (RequiredFieldValidator + RangeValidator)."""
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


def _insert(db, data: dict) -> None:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        if field in ("Prolet", "Oc"):
            values.append(int(value))
        else:
            values.append(value)
    db.execute(
        f'INSERT INTO "IPaddress4" ({columns}) VALUES ({placeholders})', values
    )
    db.commit()


def _update(db, row_id: int, data: dict) -> None:
    assignments = ", ".join(f'"{f}" = ?' for f in FIELDS)
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        if field in ("Prolet", "Oc"):
            values.append(int(value))
        else:
            values.append(value)
    values.append(row_id)
    db.execute(f'UPDATE "IPaddress4" SET {assignments} WHERE "IDPC" = ?', values)
    db.commit()


# ------------------------------------------------------------------ добавление


@bp.route("/Addipt4.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def add():
    data = {field: "" for field in FIELDS}
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
                flash("Запись добавлена.", "success")
                return redirect(url_for("ipaddr4.main"))

    return render_template(
        "ipaddr4_form.html",
        mode="add",
        data=data,
        warnings=warnings,
        error=error,
        show_force=bool(warnings),
        labels=LABELS,
        multiline=MULTILINE,
    )


# ------------------------------------------------------------ редактирование


@bp.route("/Edit.aspx", methods=("GET", "POST"))
@roles_required("editor", "admin")
def edit():
    raw_id = request.args.get("id", "")
    try:
        row_id = int(raw_id)
    except (TypeError, ValueError):
        return render_template("error.html", code=404, message="Запись не найдена."), 404

    db = get_db()
    row = db.execute('SELECT * FROM "IPaddress4" WHERE "IDPC" = ?', (row_id,)).fetchone()
    if row is None:
        return render_template("error.html", code=404, message="Запись не найдена."), 404

    data = _row_to_data(row)
    warnings: dict = {}
    error = None

    if request.method == "POST":
        validate_csrf()

        if request.form.get("action") == "delete":
            db.execute('DELETE FROM "IPaddress4" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr4.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        error = _validate_numbers(data)
        if error is None:
            warnings = _collect_warnings(data, row_id)
            if not warnings or force:
                _update(db, row_id, data)
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr4.main"))

    return render_template(
        "ipaddr4_form.html",
        mode="edit",
        row_id=row_id,
        data=data,
        warnings=warnings,
        error=error,
        show_force=bool(warnings),
        labels=LABELS,
        multiline=MULTILINE,
    )


# ------------------------------------------------------------------- поиск КЕ


@bp.route("/ReportExist.aspx")
@login_required
def report_exist():
    ke = (request.args.get("KE") or "").strip()

    sqls = [
        (
            'ТЭСЦ4',
            'SELECT "Prolet" AS "Пролет", "Uchastok" AS "Участок", '
            '"AgeregatName" AS "Номер_площадки", "Oc" AS "Ось", '
            '"ConfigLogin" AS "Логин_TS", "IPaddress", "Shluz" AS "Шлюз", "MAC", '
            '"IPaddress4"."KE", "Telephon" AS "Телефон", "Monitor" AS "Монитор", '
            '"Printer" AS "Принтер", "UPS", "Modem", "CISCO", "Opisanie" '
            'FROM "IPaddress4" WHERE "IPaddress4"."KE" LIKE ?',
        ),
        (
            'АБК',
            'SELECT "NU"."Nameuchastka" AS "Участок", "IPA"."Level" AS "Этаж", '
            '"IPA"."Kabinet" AS "Кабинет", "IPA"."ConfigLogin" AS "Логин_TS", '
            '"IPA"."IPaddress", "IPA"."MAC", "IPA"."KE" AS "KE_PC", '
            '"IPA"."Telephon" AS "Телефон", "IPA"."Monitor" AS "Монитор", '
            '"IPA"."Printer" AS "Принтер", "IPA"."UPS", "IPA"."Modem", '
            '"IPA"."CISCO", "IPA"."Opisanie" AS "Описание" '
            'FROM "IPAddressUch" AS "IPA", "NameUchastok" AS "NU" '
            'WHERE "NU"."IDUchastok" = "IPA"."IDUchastok" AND "IPA"."KE" LIKE ?',
        ),
        (
            'ТЭСЦ5',
            'SELECT "Uchastok" AS "Участок", "Oc" AS "Ось", "IPaddress5"."KE", '
            '"ConfigLogin" AS "Логин_TS", "IPaddress", "MAC", "Telephon" AS "Телефон", '
            '"Monitor" AS "Монитор", "Printer" AS "Принтер", "UPS", "Modem", "CISCO" '
            'FROM "IPaddress5" WHERE "IPaddress5"."KE" LIKE ?',
        ),
    ]

    blocks = []
    if ke:
        db = get_db()
        for title, sql in sqls:
            cursor = db.execute(sql, (f"%{ke}%",))
            rows = cursor.fetchall()
            if rows:
                blocks.append(
                    {
                        "title": title,
                        "columns": [d[0] for d in cursor.description],
                        "rows": rows,
                    }
                )

    return render_template("report.html", ke=ke, blocks=blocks)
