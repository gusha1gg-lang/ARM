"""Собирает папку ``ARM-OMK-main`` — готовый комплект для переноса на сервер.

Что попадает в комплект:

  * код приложения (``app/``) и библиотеки (``vendor/``) — запуск без `pip`;
  * рабочая база ``instance/asutp.db`` (её можно заменить миграцией из Access);
  * ресурсы legacy-сайта, которые отдаёт приложение: ``uploads/``,
    ``Slegenie/``, ``img/``, ``css/``, ``images/``, ``*.files/``, ``*.htm``;
  * запуск и автозапуск: ``serve.py``, ``start_server.bat``,
    ``install_autostart.bat``, ``remove_autostart.bat``, ``install_firewall.bat``;
  * миграция и обслуживание: ``scripts/``, ``tools/verify_db.py``,
    ``tools/backup_db.py``, ``tools/backup_db.bat``, ``App_Data/AsutpDB.mdb``;
  * документация: ``docs/``, ``README.md``, ``MIGRATION_LOG.md``,
    ``requirements*.txt``, ``.env.example``, ``КАК-ЗАПУСТИТЬ.txt``;
  * вариант для Linux: ``deploy/linux/`` копируется в ``linux/``
    (инструкция, скрипты запуска, systemd-юниты, брандмауэр, бэкап).

Не попадает: тесты (``tools/test_*.py``), ``_backup/``, ``logs/``, ``venv/``,
исходники ASP.NET (``*.aspx``, ``*.cs``, ``App_Code/``), ``.git``,
``__pycache__``, ``.env`` (создаётся на сервере автоматически).

Запуск:  python tools/build_dist.py
"""
from __future__ import annotations

import os
import shutil
import sqlite3
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
TARGET = BASE / "ARM-OMK-main"

#: Папки, которые копируются целиком (в порядке вывода).
DIRS = [
    "app",
    "vendor",
    "uploads",
    "Slegenie",
    "img",
    "css",
    "images",
    "birka_akp5.files",
    "NastroykaOPT.files",
    "Инструкция по перезапуску WinCC.files",
    "scripts",
    "docs",
]

#: Отдельные файлы (относительно корня проекта).
FILES = [
    "serve.py",
    "start_server.bat",
    "install_autostart.bat",
    "install_firewall.bat",
    "remove_autostart.bat",
    "requirements.txt",
    "requirements-dev.txt",
    ".env.example",
    "README.md",
    "MIGRATION_LOG.md",
    "birka_akp5.htm",
    "NastroykaOPT.htm",
    "tururushka.htm",
    "Инструкция по перезапуску WinCC.htm",
    "App_Data/AsutpDB.mdb",
    "tools/verify_db.py",
    "tools/backup_db.py",
    "tools/backup_db.bat",
]

IGNORE = shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo", "bin")

#: Исходники варианта для Linux (в комплект попадают как ``linux/``).
LINUX_SRC = BASE / "deploy" / "linux"
LINUX_DIR_NAME = "linux"

#: Файлы, которым на Linux нужны переводы строк LF.
LF_SUFFIXES = {".sh", ".service", ".timer", ".md", ".example", ".conf"}

HOWTO = """ARM-OMK — справочник ТЭСК ТБД
Готовый комплект для переноса на сервер (Windows 11)

СОСТАВ
  app\\        код сайта (шаблоны, стили)
  vendor\\     все библиотеки внутри проекта — pip на сервере НЕ нужен
  instance\\   рабочая база asutp.db
  uploads\\, Slegenie\\, img\\, css\\, images\\, *.files\\, *.htm
              картинки, ярлыки и инструкции оригинального сайта
  App_Data\\   исходная база Access (нужна только для миграции)
  scripts\\    миграция Access -> SQLite
  tools\\      сверка БД и резервные копии
  linux/       вариант для Linux: инструкция, systemd, брандмауэр, бэкап
  docs\\       документация (перенос — docs\\06_DEPLOY.md)

ТРЕБОВАНИЯ
  Python 3.12 или 3.13, обязательно 64-bit и в PATH.
  Проверка:  python --version
             python -c "import sys; print(sys.maxsize > 2**32)"

ЗАПУСК
  1. Скопировать эту папку целиком, например в C:\\ARM-OMK
  2. Двойной щелчок по start_server.bat
  3. Открыть http://127.0.0.1/   (без порта)
  4. Войти: admin и прежний пароль, затем шапка -> «Сменить пароль»

  При первом запуске serve.py сам создаст .env со случайным SECRET_KEY
  и папку logs\\.

LINUX
  Файлы .bat в Linux не работают. Для Linux есть отдельная инструкция
  и скрипты в папке linux/: linux/УСТАНОВКА.md (systemd, порт 80,
  ufw/firewalld, резервные копии). Код и база те же самые.

АДРЕС БЕЗ ПОРТА (http://10.100.10.1/)
  Сайт слушает порт 80 - стандартный порт HTTP, поэтому в адресе он
  не виден. В .env по умолчанию уже стоит HOST=0.0.0.0 и PORT=80.
  Порт 80 в Windows не требует прав администратора.
  Если открыть с :5000 - в .env замените PORT=5000 на PORT=80.

  Если порт 80 занят другой программой (часто IIS), serve.py напишет
  об этом и предложит варианты: остановить занявшую программу или
  поставить в .env PORT=5000 (тогда адрес будет http://<IP>:5000/).

ДОСТУП ИЗ ЛОКАЛЬНОЙ СЕТИ (один раз, от администратора)
  install_firewall.bat  ->  правый щелчок, «Запуск от имени администратора»
  Скрипт открывает входящий порт 80 для профилей «домен» и «частная сеть».

  То же вручную (PowerShell от администратора):
  New-NetFirewallRule -DisplayName "ARM-OMK web" -Direction Inbound `
    -Protocol TCP -LocalPort 80 -Action Allow -Profile Domain,Private

  После этого сайт открывается с других ПК: http://IP-этого-компьютера/

АВТОЗАПУСК ПРИ ВХОДЕ В WINDOWS
  install_autostart.bat (запуск от имени администратора)
  удалить: remove_autostart.bat

РЕЗЕРВНАЯ КОПИЯ
  tools\\backup_db.bat  ->  _backup\\db\\ (база + uploads + Slegenie)

ПЕРЕСОЗДАТЬ БАЗУ ИЗ ACCESS (если нужно)
  Нужен ODBC-драйвер «Microsoft Access Driver (*.mdb, *.accdb)».
  cd /d C:\\ARM-OMK
  python scripts\\migrate_access_to_sqlite.py
  python scripts\\migrate_legacy_admin.py
  python tools\\verify_db.py
  Подробно: docs\\06_DEPLOY.md, пункт 4.

ПРОВЕРКА, ЧТО ВСЁ ЖИВО
  http://127.0.0.1/health  ->  {"status":"ok"}
  журнал: logs\\app.log
  если порт другой: http://127.0.0.1:<PORT>/health
"""


def human(size: int) -> str:
    for unit in ("Б", "КБ", "МБ", "ГБ"):
        if size < 1024 or unit == "ГБ":
            return f"{size:.1f} {unit}" if unit != "Б" else f"{size} Б"
        size /= 1024
    return f"{size:.1f} ГБ"


def copy_db(src: Path, dst: Path) -> None:
    """Согласованный снимок SQLite: учитывает данные из журнала WAL.

    Копировать файл ``.db`` напрямую нельзя, если рядом есть ``-wal``:
    часть свежих записей ещё лежит в нём.

    Готовый файл переводится в режим ``journal_mode=DELETE`` — тогда база
    лежит одним файлом без ``-wal``/``-shm`` и её можно копировать целиком.
    Рабочий WAL включается приложением при первом запуске (``app/__init__.py``).
    """
    dst.parent.mkdir(parents=True, exist_ok=True)
    for suffix in ("-wal", "-shm"):
        stale = Path(str(dst) + suffix)
        if stale.exists():
            stale.unlink()

    source = sqlite3.connect(src)
    target = sqlite3.connect(dst)
    try:
        with target:
            source.backup(target)
        target.execute("PRAGMA journal_mode = DELETE").fetchone()
    finally:
        target.close()
        source.close()

    for suffix in ("-wal", "-shm"):
        stale = Path(str(dst) + suffix)
        if stale.exists():
            stale.unlink()


def copy_linux(src: Path, dst: Path) -> None:
    """Скопировать скрипты и инструкцию для Linux, приведя текст к LF.

    bash и systemd не понимают переводы строк CRLF: скрипт падает с
    ``bad interpreter: /usr/bin/env bash^M``, юнит — с ошибкой разбора.
    В git файлы хранятся с LF (см. ``.gitattributes``), но рабочая копия на
    Windows может быть выгружена с CRLF, поэтому приводим явно.
    """
    shutil.copytree(src, dst, ignore=IGNORE)
    for path in dst.rglob("*"):
        if path.is_file() and path.suffix in LF_SUFFIXES:
            data = path.read_bytes()
            fixed = data.replace(b"\r\n", b"\n")
            if fixed != data:
                path.write_bytes(fixed)


def tree_size(path: Path) -> int:
    total = 0
    for root, _dirs, files in os.walk(path):
        for name in files:
            try:
                total += (Path(root) / name).stat().st_size
            except OSError:
                pass
    return total


def _check_clean(target: Path) -> list[str]:
    """Проверить, что в комплект не попали рабочие артефакты.

    Такие файлы появляются, если в папке сборки запускали сервер:
    ``.env`` с боевым ключом, ``logs/``, ``__pycache__``.
    """
    problems: list[str] = []
    for name in (".env", "logs"):
        if (target / name).exists():
            problems.append(name)
    for path in target.rglob("*"):
        rel = path.relative_to(target)
        if path.is_dir() and path.name == "__pycache__":
            problems.append(str(rel))
        elif path.is_file() and path.suffix in (".pyc", ".pyo"):
            problems.append(str(rel))
        elif path.is_file() and path.name.startswith("test_") and path.suffix == ".py":
            problems.append(str(rel))
        elif path.is_file() and path.name.endswith(("-wal", "-shm")):
            problems.append(str(rel))
    return problems


def main() -> int:
    # Сначала проверяем, что всё на месте, — чтобы не получить половину комплекта.
    missing = [p for p in DIRS if not (BASE / p).is_dir()]
    missing += [p for p in FILES if not (BASE / p).is_file()]
    if not LINUX_SRC.is_dir():
        missing.append(str(LINUX_SRC.relative_to(BASE)))
    if missing:
        print("ОШИБКА: не найдены обязательные элементы:", file=sys.stderr)
        for p in missing:
            print("  ", p, file=sys.stderr)
        return 1

    db = BASE / "instance" / "asutp.db"
    con = sqlite3.connect(db)
    tables = [r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table' "
        "AND name NOT LIKE 'sqlite_%' ORDER BY name")]
    rows = sum(con.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0] for t in tables)
    con.close()

    if TARGET.exists():
        print(f"Удаляю прежнюю сборку: {TARGET}")
        shutil.rmtree(TARGET)
    TARGET.mkdir(parents=True)

    print(f"База: {db.name} — {len(tables)} таблиц, {rows} строк\n")

    for name in DIRS:
        src = BASE / name
        dst = TARGET / name
        shutil.copytree(src, dst, ignore=IGNORE)
        print(f"  {name:<40} {human(tree_size(dst)):>10}")

    for name in FILES:
        src = BASE / name
        dst = TARGET / name
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
        print(f"  {name:<40} {human(dst.stat().st_size):>10}")

    copy_linux(LINUX_SRC, TARGET / LINUX_DIR_NAME)
    print(f"  {'linux/ (для Linux)':<40} "
          f"{human(tree_size(TARGET / LINUX_DIR_NAME)):>10}")

    copy_db(BASE / "instance" / "asutp.db", TARGET / "instance" / "asutp.db")
    print(f"  {'instance/asutp.db (снимок)':<40} "
          f"{human((TARGET / 'instance' / 'asutp.db').stat().st_size):>10}")

    howto = TARGET / "КАК-ЗАПУСТИТЬ.txt"
    howto.write_text(HOWTO, encoding="utf-8-sig", newline="\r\n")

    leftovers = _check_clean(TARGET)
    if leftovers:
        print("\nОШИБКА: в комплекте остались рабочие артефакты:", file=sys.stderr)
        for item in leftovers[:20]:
            print("  ", item, file=sys.stderr)
        print("  Запускали сервер из папки сборки? Пересоберите комплект.",
              file=sys.stderr)
        return 1
    print("  проверка чистоты:                   OK (нет .env, logs, __pycache__)")

    total = tree_size(TARGET)
    files = sum(len(f) for _r, _d, f in os.walk(TARGET))
    print(f"\nГотово: {TARGET}")
    print(f"Файлов: {files}, объём: {human(total)}")
    print("Проверка запуска: start_server.bat (см. КАК-ЗАПУСТИТЬ.txt)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
