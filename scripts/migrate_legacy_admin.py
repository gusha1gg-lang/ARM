"""Перенос легаси-пользователя из UserPass в users.

По плану (docs/01_PLAN.md, шаг 5.4 / 3.1): существующий пользователь
`UserPass` получает учётную запись в новой таблице `users` с ролью `admin`,
пароль хешируется PBKDF2-SHA256 (первый вход — тем же паролем).

Скрипт идемпотентен: если пользователь с таким логином уже есть — пропускает.

Запуск:  python scripts/migrate_legacy_admin.py
"""
from __future__ import annotations

import os
import sqlite3
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# На сервере сторонние библиотеки лежат в vendor/ — pip там недоступен.
VENDOR_DIR = os.path.join(BASE_DIR, "vendor")
if os.path.isdir(VENDOR_DIR) and VENDOR_DIR not in sys.path:
    sys.path.insert(0, VENDOR_DIR)

from werkzeug.security import generate_password_hash  # noqa: E402

SQLITE_PATH = os.path.join(BASE_DIR, "instance", "asutp.db")


def main() -> int:
    if not os.path.exists(SQLITE_PATH):
        print(f"ОШИБКА: нет базы {SQLITE_PATH}. Сначала выполните миграцию.", file=sys.stderr)
        return 1

    conn = sqlite3.connect(SQLITE_PATH)
    conn.row_factory = sqlite3.Row

    legacy = conn.execute('SELECT "UserID", "Login", "Pass" FROM "UserPass"').fetchall()
    if not legacy:
        print("В UserPass нет пользователей — переносить нечего.")
        conn.close()
        return 0

    created = 0
    skipped = 0
    for row in legacy:
        login = (row["Login"] or "").strip()
        password = row["Pass"] or ""
        if not login:
            print(f"  UserID={row['UserID']}: пустой логин, пропущен.")
            skipped += 1
            continue

        exists = conn.execute(
            "SELECT 1 FROM users WHERE username = ? COLLATE NOCASE", (login,)
        ).fetchone()
        if exists:
            print(f"  «{login}»: уже есть в users — пропущен.")
            skipped += 1
            continue

        conn.execute(
            "INSERT INTO users (username, password_hash, role) VALUES (?, ?, 'admin')",
            (login, generate_password_hash(password)),
        )
        created += 1
        print(f"  «{login}»: перенесён с ролью admin.")

    conn.commit()
    conn.close()

    print(f"\nСоздано: {created}, пропущено: {skipped}.")
    if created:
        print("ВАЖНО: пароль остался прежним. Смените его в разделе «Пользователи».")
    return 0


if __name__ == "__main__":
    sys.exit(main())
