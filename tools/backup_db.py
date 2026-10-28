"""Резервная копия БД (и, по желанию, файлов) ARM-OMK.

Запуск:
    python tools/backup_db.py              # только БД
    python tools/backup_db.py --with-files # БД + uploads/ + Slegenie/
    python tools/backup_db.py --keep 60    # хранить 60 последних копий

Копия БД делается через sqlite3 backup API: она корректна и при включённом
WAL (обычное копирование файла в этот момент может дать «битую» базу).
"""
from __future__ import annotations

import argparse
import shutil
import sqlite3
import sys
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
BACKUP_ROOT = BASE_DIR / "_backup"
FILE_DIRS = ("uploads", "Slegenie")


def read_env() -> dict[str, str]:
    path = BASE_DIR / ".env"
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def backup_database(source: Path, target: Path) -> int:
    """Скопировать БД и вернуть количество таблиц в копии."""
    target.parent.mkdir(parents=True, exist_ok=True)
    src = sqlite3.connect(f"file:{source.as_posix()}?mode=ro", uri=True)
    try:
        dst = sqlite3.connect(target)
        try:
            src.backup(dst)
            result = dst.execute("PRAGMA integrity_check").fetchone()[0]
            if result != "ok":
                raise RuntimeError(f"integrity_check: {result}")
            return dst.execute(
                "SELECT COUNT(*) FROM sqlite_master "
                "WHERE type='table' AND name NOT LIKE 'sqlite_%'"
            ).fetchone()[0]
        finally:
            dst.close()
    finally:
        src.close()


def prune(folder: Path, keep: int) -> int:
    files = sorted(folder.glob("asutp-*.db"))
    removed = 0
    for old in files[:-keep] if keep > 0 else []:
        old.unlink()
        removed += 1
    return removed


def main() -> int:
    parser = argparse.ArgumentParser(description="Резервная копия ARM-OMK")
    parser.add_argument("--with-files", action="store_true",
                        help="копировать uploads/ и Slegenie/")
    parser.add_argument("--keep", type=int, default=30,
                        help="сколько копий БД хранить (по умолчанию 30)")
    args = parser.parse_args()

    env = read_env()
    source = BASE_DIR / env.get("DATABASE_PATH", "instance/asutp.db")
    if not source.exists():
        print(f"ОШИБКА: файл БД не найден: {source}")
        return 1

    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    db_folder = BACKUP_ROOT / "db"
    target = db_folder / f"asutp-{stamp}.db"

    try:
        tables = backup_database(source, target)
    except (sqlite3.Error, RuntimeError) as exc:
        print(f"ОШИБКА резервного копирования: {exc}")
        return 1

    size_mb = target.stat().st_size / 1024 / 1024
    print(f"БД:      {source}")
    print(f"копия:   {target}  ({size_mb:.1f} МБ, таблиц: {tables})")

    if args.with_files:
        files_target = BACKUP_ROOT / "files" / stamp
        for name in FILE_DIRS:
            src_dir = BASE_DIR / name
            if not src_dir.is_dir():
                print(f"пропуск:  {name}/ не найден")
                continue
            shutil.copytree(src_dir, files_target / name, dirs_exist_ok=True)
            print(f"файлы:   {name}/ -> {files_target / name}")

    removed = prune(db_folder, args.keep)
    if removed:
        print(f"удалено старых копий: {removed}")

    print("Готово.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
