"""Проверка готовности комплекта ``ARM-OMK-main`` к переносу на сервер.

Запуск (из корня проекта)::

    python tools\\check_dist.py

Проверяет состав папки, отсутствие рабочих артефактов (``.env``, ``logs``,
``__pycache__``), библиотеки, ресурсы, базу данных, кодировки и настройки.
Сервер для этого не нужен — только чтение файлов.

Код возврата: 0 — можно переносить, 1 — есть проблемы.
Предупреждения (например, ссылка на отсутствующую картинку, унаследованная
из старой базы) на код возврата не влияют.
"""
from __future__ import annotations

import re
import sqlite3
import sys
from pathlib import Path
from urllib.parse import unquote

BASE = Path(__file__).resolve().parent.parent
DIST = BASE / "ARM-OMK-main"

problems: list[str] = []
warnings: list[str] = []


def ok(text: str) -> None:
    print(f"  OK   {text}")


def fail(text: str) -> None:
    print(f"  ПЛОХО {text}")
    problems.append(text)


def warn(text: str) -> None:
    print(f"  !    {text}")
    warnings.append(text)


def check(cond: bool, good: str, bad: str) -> None:
    if cond:
        ok(good)
    else:
        fail(bad)


def section(title: str) -> None:
    print()
    print("=" * 74)
    print(title)
    print("=" * 74)


def main() -> int:
    if not DIST.is_dir():
        print(f"Нет папки {DIST}. Соберите комплект: python tools\\build_dist.py")
        return 1

    files = [p for p in DIST.rglob("*") if p.is_file()]
    size = sum(p.stat().st_size for p in files)

    section("1. СОСТАВ")
    print(f"  файлов: {len(files)}, объём: {size / 1024 / 1024:.1f} МБ")

    for d in ("app", "app/templates", "app/static/css", "vendor", "instance",
              "uploads", "Slegenie", "img", "css", "images", "scripts", "docs",
              "tools", "birka_akp5.files", "NastroykaOPT.files",
              "Инструкция по перезапуску WinCC.files", "App_Data"):
        check((DIST / d).is_dir(), f"папка {d}", f"нет папки {d}")

    for f in ("serve.py", "start_server.bat", "install_firewall.bat",
              "install_autostart.bat", "remove_autostart.bat",
              "requirements.txt", ".env.example", "README.md",
              "MIGRATION_LOG.md", "КАК-ЗАПУСТИТЬ.txt", "birka_akp5.htm",
              "NastroykaOPT.htm", "tururushka.htm",
              "Инструкция по перезапуску WinCC.htm", "App_Data/AsutpDB.mdb",
              "instance/asutp.db", "tools/verify_db.py", "tools/backup_db.py",
              "tools/backup_db.bat", "scripts/migrate_access_to_sqlite.py",
              "scripts/migrate_legacy_admin.py", "scripts/schema.sql"):
        check((DIST / f).is_file(), f"файл {f}", f"нет файла {f}")

    print("\n  рабочих артефактов быть не должно:")
    check(not (DIST / ".env").exists(), "нет .env (создастся на сервере)",
          "есть .env — в нём боевой SECRET_KEY, удалите и пересоберите")
    check(not (DIST / "logs").exists(), "нет logs/", "есть logs/ (журналы разработчика)")
    check(not list(DIST.rglob("__pycache__")), "нет __pycache__", "есть __pycache__")
    check(not list(DIST.rglob("*.pyc")), "нет .pyc", "есть .pyc")
    check(not list(DIST.rglob("test_*.py")), "нет тестов", "есть тесты")
    check(not (DIST / "_backup").exists(), "нет _backup/", "есть _backup/")
    check(not (DIST / ".git").exists(), "нет .git/", "есть .git/")
    check(not (DIST / "venv").exists(), "нет venv/", "есть venv/")
    check(not list(DIST.rglob("*.aspx")), "нет *.aspx", "есть *.aspx")
    check(not list(DIST.rglob("App_Code")), "нет App_Code/", "есть App_Code/")
    check(not list(DIST.rglob("*-wal")) and not list(DIST.rglob("*-shm")),
          "нет -wal/-shm рядом с БД", "есть -wal/-shm: база не одним файлом")

    section("2. БИБЛИОТЕКИ (vendor/)")
    packages = {"Flask": "3.1.3", "Werkzeug": "3.1.9", "Jinja2": "3.1.6",
                "MarkupSafe": "3.0.4", "click": "8.5.0",
                "itsdangerous": "2.2.0", "blinker": "1.9.0",
                "python_dotenv": "1.2.4", "waitress": "3.0.2", "pyodbc": "5.3.0"}
    for name, ver in packages.items():
        check((DIST / "vendor" / f"{name}-{ver}.dist-info").is_dir(),
              f"{name} {ver}", f"нет {name} {ver}")

    pyd = {p.relative_to(DIST / "vendor").as_posix()
           for p in (DIST / "vendor").rglob("*.pyd")}
    print("  бинарные модули:", ", ".join(sorted(pyd)) or "нет")
    check("pyodbc.cp312-win_amd64.pyd" in pyd, "pyodbc для Python 3.12",
          "нет pyodbc для Python 3.12")
    check("pyodbc.cp313-win_amd64.pyd" in pyd, "pyodbc для Python 3.13",
          "нет pyodbc для Python 3.13")
    check("markupsafe/_speedups.cp313-win_amd64.pyd" in pyd,
          "markupsafe: ускорение для 3.13", "нет markupsafe._speedups")
    check(len(list((DIST / "vendor").rglob("LICENSE*"))) >= 8,
          "тексты лицензий на месте", "мало файлов лицензий")

    section("3. КОД И РЕСУРСЫ")
    tpl = list((DIST / "app" / "templates").glob("*.html"))
    mods = list((DIST / "app").glob("*.py"))
    print(f"  шаблонов: {len(tpl)}, модулей app/: {len(mods)}, "
          f"style.css: {(DIST / 'app/static/css/style.css').stat().st_size} байт")
    check(len(tpl) == 25, "25 шаблонов", f"шаблонов {len(tpl)}, ожидалось 25")
    check(len(mods) == 19, "19 модулей app/", f"модулей {len(mods)}, ожидалось 19")

    for name, minimum in (("uploads", 80), ("images", 10), ("Slegenie", 30),
                          ("img", 40), ("css", 20)):
        count = len(list((DIST / name).glob("*")))
        check(count >= minimum, f"{name}: {count} объектов",
              f"{name}: только {count} объектов")

    docs = sorted(p.name for p in (DIST / "docs").glob("*.md"))
    print(f"  документация: {len(docs)} файлов")
    check(len(docs) >= 8, "docs/ — 8 документов", "не хватает документов в docs/")

    section("4. ВАРИАНТ ДЛЯ LINUX")
    linux_dir = DIST / "linux"
    check(linux_dir.is_dir(), "папка linux/ на месте", "нет папки linux/")
    if linux_dir.is_dir():
        for name in ("УСТАНОВКА.md", "start_server.sh", "install_service.sh",
                     "uninstall_service.sh", "install_firewall.sh",
                     "backup_db.sh", "install_backup_timer.sh",
                     "arm-omk.service", "arm-omk-backup.service",
                     "arm-omk-backup.timer", "nginx-arm-omk.conf.example"):
            check((linux_dir / name).is_file(), f"linux/{name}",
                  f"нет linux/{name}")

        crlf = [p.name for p in linux_dir.rglob("*")
                if p.is_file() and p.suffix in (".sh", ".service", ".timer")
                and b"\r\n" in p.read_bytes()]
        check(not crlf, "скрипты и юниты с LF (bash и systemd поймут)",
              f"переводы строк CRLF в: {crlf}")

        script = linux_dir / "start_server.sh"
        if script.is_file():
            check(script.read_bytes().startswith(b"#!/usr/bin/env bash"),
                  "start_server.sh с шебангом", "у start_server.sh нет шебанга")

        unit = linux_dir / "arm-omk.service"
        if unit.is_file():
            text = unit.read_text(encoding="utf-8")
            check(all(token in text for token in ("@ROOT@", "@USER@", "@PYTHON@")),
                  "шаблон юнита с подстановками @ROOT@/@USER@/@PYTHON@",
                  "в шаблоне юнита нет подстановок")
            check("AmbientCapabilities=CAP_NET_BIND_SERVICE" in text,
                  "порт 80 без root (CAP_NET_BIND_SERVICE)",
                  "в юните нет CAP_NET_BIND_SERVICE")

    section("5. БАЗА ДАННЫХ")
    db = DIST / "instance" / "asutp.db"
    con = sqlite3.connect(f"file:{db}?mode=ro&immutable=1", uri=True)
    tables = [r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table' "
        "AND name NOT LIKE 'sqlite_%' ORDER BY name")]
    check(len(tables) == 16, "16 таблиц", f"таблиц {len(tables)}, ожидалось 16")

    legacy = ("NameShop", "NameUchastok", "NameProlet", "IPaddress4",
              "IPaddress5", "IPaddressAll", "IPAddressUch", "Jarlik",
              "SPR_CAMERA", "SPR_CISCO", "UserPass", "Video_Camera_all",
              "telefon", "temp")
    rows = {t: con.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
            for t in legacy}
    total = sum(rows.values())
    print("  строк:", ", ".join(f"{t}={n}" for t, n in rows.items()))
    check(total == 3880, f"legacy-строк: {total}", f"legacy-строк {total}, ожидалось 3880")

    users = con.execute("SELECT COUNT(*) FROM users").fetchone()[0]
    admins = con.execute(
        "SELECT COUNT(*) FROM users WHERE role='admin'").fetchone()[0]
    check(admins >= 1, f"пользователей: {users}, admin: {admins}",
          "нет пользователя с ролью admin")
    check(con.execute("PRAGMA integrity_check").fetchone()[0] == "ok",
          "integrity_check = ok", "integrity_check не ok")
    check(not con.execute("PRAGMA foreign_key_check").fetchall(),
          "внешние ключи в порядке", "нарушены внешние ключи")
    mode = con.execute("PRAGMA journal_mode").fetchone()[0]
    if mode.lower() == "wal":
        ok("journal_mode = wal (включится при первом запуске)")
    elif mode.lower() == "delete":
        ok("journal_mode = delete — база одним файлом, WAL включится при старте")
    else:
        warn(f"journal_mode = {mode}")

    print("\n  кириллица (выборка):")
    samples = ("SELECT ShopName FROM NameShop LIMIT 3",
               "SELECT Nameuchastka FROM NameUchastok LIMIT 3",
               "SELECT Prolet_name FROM NameProlet LIMIT 3",
               "SELECT fio FROM telefon LIMIT 3")
    cyr_ok = True
    for query in samples:
        values = [r[0] for r in con.execute(query)]
        print("   ", values)
        for value in values:
            if value and not re.search(r"[А-Яа-яЁё]", str(value)):
                cyr_ok = False
    check(cyr_ok, "кириллица читается корректно", "кириллица испорчена")

    refs: set[str] = set()
    for table in tables:
        for col in [c[1] for c in con.execute(f'PRAGMA table_info("{table}")')]:
            try:
                found = con.execute(
                    f'SELECT DISTINCT "{col}" FROM "{table}" '
                    f'WHERE "{col}" LIKE "%/%" OR "{col}" LIKE "%\\\\%"').fetchall()
            except sqlite3.Error:
                continue
            for (value,) in found:
                if isinstance(value, str) and re.search(
                        r"\.(jpg|jpeg|png|gif|bmp|lnk|url|cer|pdf|doc|docx|xls|xlsx|htm|html)$",
                        value, re.I):
                    refs.add(value)

    missing = []
    for value in sorted(refs):
        if value.lower().startswith(("http://", "https://", "\\\\")):
            continue
        clean = unquote(value.split("?")[0]).replace("\\", "/").lstrip("/")
        if not any(candidate.exists() for candidate in (
                DIST / clean,
                DIST / "uploads" / Path(clean).name,
                DIST / "Slegenie" / Path(clean).name)):
            missing.append(value)
    con.close()

    print(f"\n  ссылок на файлы в БД: {len(refs)}, не найдено: {len(missing)}")
    if missing:
        for item in missing:
            warn(f"нет файла {item} (ссылка унаследована из старой базы)")
    else:
        ok("все файлы по ссылкам из БД есть")

    section("6. КОДИРОВКИ")
    bad = []
    for path in files:
        if path.suffix == ".bat" or path.name == "КАК-ЗАПУСТИТЬ.txt":
            continue
        if path.suffix in (".py", ".html", ".css", ".js", ".md", ".txt",
                           ".sql", ".json") or path.name == ".env.example":
            try:
                path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                bad.append(path.relative_to(DIST).as_posix())
    check(not bad, "текстовые файлы в UTF-8", f"не UTF-8: {bad[:5]}")

    bad = [p.name for p in DIST.rglob("*.bat")
           if not _decodes(p.read_bytes(), "cp866")]
    check(not bad, ".bat в cp866 (русский текст в консоли)",
          f"не cp866: {bad}")

    howto = (DIST / "КАК-ЗАПУСТИТЬ.txt").read_bytes()
    check(howto.startswith(b"\xef\xbb\xbf"),
          "КАК-ЗАПУСТИТЬ.txt с BOM (Блокнот откроет правильно)", "нет BOM")
    check(b"\r\n" in howto, "КАК-ЗАПУСТИТЬ.txt с CRLF", "нет CRLF")

    section("7. НАСТРОЙКИ")
    env = (DIST / ".env.example").read_text(encoding="utf-8")
    for key, value in (("PORT", "80"), ("HOST", "0.0.0.0"), ("DEBUG", "0")):
        check(f"{key}={value}" in env, f".env.example: {key}={value}",
              f".env.example: {key} не {value}")
    check("SECRET_KEY=change-me" in env,
          ".env.example: ключ-заглушка (не боевой)", "странный SECRET_KEY")

    serve = (DIST / "serve.py").read_text(encoding="utf-8")
    check("PORT=80" in serve, "serve.py: создаёт .env с PORT=80",
          "serve.py: PORT не 80")
    check("SECRET_KEY={secret}" in serve, "serve.py: генерирует SECRET_KEY",
          "serve.py: нет генерации ключа")
    check("_port_is_free" in serve, "serve.py: проверяет занятый порт",
          "serve.py: нет проверки порта")

    hits = [p.relative_to(DIST).as_posix() for p in files
            if p.suffix in (".py", ".html", ".css", ".js")
            and "vendor" not in p.parts
            and re.search(r"[Cc]:[\\/]Users[\\/]gusha",
                          p.read_text(encoding="utf-8", errors="ignore"))]
    check(not hits, "нет путей C:\\Users\\gusha", f"жёсткие пути: {hits}")

    section("ИТОГ")
    if problems:
        print(f"ПРОБЛЕМ: {len(problems)} — переносить рано.")
        for item in problems:
            print("  -", item)
        if warnings:
            print(f"Предупреждений: {len(warnings)}.")
        return 1
    print(f"Комплект готов к переносу. Предупреждений: {len(warnings)}.")
    for item in warnings:
        print("  !", item)
    return 0


def _decodes(data: bytes, encoding: str) -> bool:
    try:
        data.decode(encoding)
    except UnicodeDecodeError:
        return False
    return True


if __name__ == "__main__":
    sys.exit(main())
