"""Миграция данных из MS Access (AsutpDB.mdb) в SQLite (instance/asutp.db).

Принципы:
  * все 14 пользовательских таблиц переносятся 1-в-1;
  * имена таблиц/полей не меняются;
  * значения AutoNumber (ID) сохраняются явной вставкой;
  * NULL остаётся NULL;
  * кодировка — UTF-8 (кириллица и спецсимволы сохраняются).

Запуск:  python scripts/migrate_access_to_sqlite.py
"""
from __future__ import annotations

import os
import sqlite3
import sys

import pyodbc

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MDB_PATH = os.path.join(BASE_DIR, "App_Data", "AsutpDB.mdb")
SQLITE_PATH = os.path.join(BASE_DIR, "instance", "asutp.db")
SCHEMA_PATH = os.path.join(BASE_DIR, "scripts", "schema.sql")

# Таблицы в порядке переноса. Первичные ключи нужны для сортировки и сверки.
TABLES = [
    ("NameShop", "ShopID"),
    ("NameUchastok", "IDUchastok"),
    ("NameProlet", "ProletID"),
    ("IPaddress4", "IDPC"),
    ("IPaddress5", "IDPC"),
    ("IPaddressAll", "IDPC"),
    ("IPAddressUch", "IDPC"),
    ("Jarlik", "IDJarlik"),
    ("SPR_CAMERA", "IDCAM_NAME"),
    ("SPR_CISCO", "ID_CISCO"),
    ("UserPass", "UserID"),
    ("Video_Camera_all", "ID_VID_CAM"),
    ("telefon", "id"),
    ("temp", "idt"),
]


def connect_access() -> pyodbc.Connection:
    conn_str = (
        r"Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
        rf"DBQ={MDB_PATH};"
    )
    return pyodbc.connect(conn_str)


def main() -> int:
    if not os.path.exists(MDB_PATH):
        print(f"ОШИБКА: не найден файл Access: {MDB_PATH}", file=sys.stderr)
        return 1

    if os.path.exists(SQLITE_PATH):
        os.remove(SQLITE_PATH)
        print(f"Удалён старый файл SQLite: {SQLITE_PATH}")

    os.makedirs(os.path.dirname(SQLITE_PATH), exist_ok=True)

    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        schema_sql = f.read()

    lite = sqlite3.connect(SQLITE_PATH)
    lite.executescript(schema_sql)
    lite.commit()

    access = connect_access()
    acur = access.cursor()

    total_rows = 0
    report = []

    # Перенос данных: FK отключаем на время загрузки, проверяем отдельно.
    lite.execute("PRAGMA foreign_keys = OFF")
    try:
        for table, pk in TABLES:
            acur.execute(f"SELECT * FROM [{table}]")
            columns = [d[0] for d in acur.description]
            rows = acur.fetchall()

            quoted_cols = ", ".join(f'"{c}"' for c in columns)
            placeholders = ", ".join("?" for _ in columns)
            insert_sql = f'INSERT INTO "{table}" ({quoted_cols}) VALUES ({placeholders})'

            lite.executemany(insert_sql, [tuple(r) for r in rows])
            lite.commit()

            total_rows += len(rows)
            report.append((table, len(rows)))
            print(f"  {table}: {len(rows)} строк")

        # Сброс счётчиков AUTOINCREMENT на фактический максимум ID.
        for table, pk in TABLES:
            max_id = lite.execute(f'SELECT COALESCE(MAX("{pk}"), 0) FROM "{table}"').fetchone()[0]
            lite.execute("DELETE FROM sqlite_sequence WHERE name = ?", (table,))
            lite.execute(
                "INSERT INTO sqlite_sequence(name, seq) VALUES (?, ?)",
                (table, max_id),
            )
        lite.commit()
    finally:
        acur.close()
        access.close()

    # Проверка внешних ключей после загрузки.
    lite.execute("PRAGMA foreign_keys = ON")
    fk_violations = lite.execute("PRAGMA foreign_key_check").fetchall()

    print("\nИтого строк:", total_rows)
    if fk_violations:
        print("ВНИМАНИЕ: нарушения внешних ключей:", fk_violations[:20], file=sys.stderr)
        lite.close()
        return 2

    lite.close()
    print("Миграция завершена успешно.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
