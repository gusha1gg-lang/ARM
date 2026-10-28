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

from .audit import last_change, log_action
from .db import get_db
from .ip_shared import find_duplicates
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

#: Нижняя граница «Номера пролета». Пролёт -1 существует в справочнике
#: NameProlet («Пролет №-1 Ф-Ц») и в таблице IPaddress4.
PROLET_MIN = -1000

# Текст предупреждения — дословно из оригинальных валидаторов.
DUPLICATE_MESSAGE = "КЕ с таким номером уже существует, ты уверен что желаешь сохранить?"


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


def _collect_warnings(data: dict, exclude_id: int | None) -> dict:
    warnings = {}
    for field in ("KE", "Monitor", "Printer"):
        if find_duplicates(field, data.get(field) or "", exclude_id):
            warnings[field] = DUPLICATE_MESSAGE
    return warnings


def _validate_numbers(data: dict) -> tuple[str | None, str | None]:
    """Проверка числовых полей (RequiredFieldValidator + RangeValidator).

    Возвращает пару (блокирующая_ошибка, ошибка_диапазона).

    * Блокирующую ошибку (поле пустое или не является числом) обойти нельзя:
      без числа запись в БД невозможна.
    * Ошибку диапазона можно обойти кнопкой «Все равно сохранить» —
      в оригинале это была кнопка Button2 на Addipt4.aspx.

    Нижняя граница пролёта — -1000, а не 0: в справочнике NameProlet есть
    пролёт -1 («Пролет №-1 Ф-Ц»), и в самой таблице уже есть такие записи.
    В оригинале отрицательный пролёт вводился именно через «Все равно
    сохранить».
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


def _log_details(data: dict) -> str:
    """Краткое описание записи для журнала действий."""
    return (
        f"пролет {data.get('Prolet') or '—'}, "
        f"ось {data.get('Oc') or '—'}, "
        f"участок {data.get('Uchastok') or '—'}, "
        f"КЕ {data.get('KE') or '—'}, "
        f"IP {data.get('IPaddress') or '—'}"
    )


def _insert(db, data: dict) -> int:
    columns = ", ".join(f'"{f}"' for f in FIELDS)
    placeholders = ", ".join("?" for _ in FIELDS)
    values = []
    for field in FIELDS:
        value = data.get(field) or ""
        if field in ("Prolet", "Oc"):
            values.append(int(value))
        else:
            values.append(value)
    cursor = db.execute(
        f'INSERT INTO "IPaddress4" ({columns}) VALUES ({placeholders})', values
    )
    db.commit()
    return cursor.lastrowid


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
                log_action("create", "IPaddress4", new_id, _log_details(data))
                flash("Запись добавлена.", "success")
                return redirect(url_for("ipaddr4.main"))
            error = range_error
            show_force = True

    return render_template(
        "ip_form.html",
        mode="add",
        data=data,
        warnings=warnings,
        error=error,
        show_force=show_force,
        labels=LABELS,
        multiline=MULTILINE,
        autofocus="Prolet",
        form_action=url_for("ipaddr4.add"),
        back_url=url_for("ipaddr4.main"),
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
    show_force = False

    if request.method == "POST":
        validate_csrf()

        if request.form.get("action") == "delete":
            db.execute('DELETE FROM "IPaddress4" WHERE "IDPC" = ?', (row_id,))
            db.commit()
            log_action("delete", "IPaddress4", row_id,
                       _log_details(_row_to_data(row)))
            flash(f"Запись №{row_id} удалена.", "success")
            return redirect(url_for("ipaddr4.main"))

        data = _form_data()
        force = request.form.get("force") == "1"

        blocking, range_error = _validate_numbers(data)
        if blocking is not None:
            error = blocking
        else:
            warnings = _collect_warnings(data, row_id)
            if force or (range_error is None and not warnings):
                _update(db, row_id, data)
                log_action("update", "IPaddress4", row_id, _log_details(data))
                flash("Изменения сохранены.", "success")
                return redirect(url_for("ipaddr4.main"))
            error = range_error
            show_force = True

    return render_template(
        "ip_form.html",
        mode="edit",
        row_id=row_id,
        data=data,
        warnings=warnings,
        error=error,
        show_force=show_force,
        labels=LABELS,
        multiline=MULTILINE,
        autofocus="Prolet",
        form_action=url_for("ipaddr4.edit", id=row_id),
        back_url=url_for("ipaddr4.main"),
        last_change_info=last_change("IPaddress4", row_id),
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
