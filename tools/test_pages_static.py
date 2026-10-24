"""Сквозной тест статических страниц (Этап 4, партия 10).

Проверяет /Webnav.aspx, /Nastroyki.aspx, /NastoikaT5.aspx, /NastoikaEBS.aspx,
/Calendar.aspx, готовые .htm оригинала (NastroykaOPT, birka_akp5, tururushka,
Инструкция по перезапуску WinCC) и их папки *.files: доступ после входа,
содержимое, кодировку, картинки и белый список файлов.

Запуск (при работающем сервере):  python tools/test_pages_static.py
"""
from __future__ import annotations

import http.cookiejar
import os
import re
import sqlite3
import sys
import urllib.error
import urllib.parse
import urllib.request

BASE = "http://127.0.0.1:5000"
CSRF_RE = re.compile(r'name="_csrf" value="([^"]+)"')
DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                       "instance", "asutp.db")

#: Статические aspx-страницы: URL → признаки содержимого.
PAGES = {
    "/Webnav.aspx": ("WEB NAVIGATOR", "Форма для мастеров", "scada-003.d0.vsw.ru"),
    "/Nastroyki.aspx": ("Список настроек", "/NastroykaOPT.htm",
                        "Настройка ручных сканеров Symbol", "/Настройка ODBC.htm"),
    "/NastoikaT5.aspx": ("Настройка Zebra в ТЭСЦ 5",
                         "images/T51.jpg", "images/T52.jpg",
                         "images/T53.jpg", "images/T54.jpg"),
    "/NastoikaEBS.aspx": ("Настройка маркировщика EBS-250", "UNIT_ID", "Adr="),
    "/Calendar.aspx": ("Январь", "Февраль", "Декабрь", "Понедельник"),
}

#: Готовые .htm: URL → (кодировка из meta, ожидаемый текст).
HTM_FILES = {
    "/NastroykaOPT.htm": ("windows-1251", "Настройка печати бирок"),
    "/birka_akp5.htm": ("windows-1251", "Настройка печати бирок на АКП5"),
    "/tururushka.htm": ("windows-1252", "WT4090"),
    "/Инструкция по перезапуску WinCC.htm": ("windows-1251", "WinCC"),
}

results = []


def check(name: str, ok: bool, extra: str = "") -> None:
    results.append((name, ok, extra))
    print(f"{'OK  ' if ok else 'FAIL'} {name}{(' - ' + extra) if extra else ''}")


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def make_opener():
    jar = http.cookiejar.CookieJar()
    return urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(jar), NoRedirect()
    )


def fetch(opener, path, data=None):
    body = urllib.parse.urlencode(data).encode() if data is not None else None
    # Кириллица и пробелы в адресах .htm кодируются, готовые %XX не трогаем.
    url = BASE + urllib.parse.quote(path, safe="/?&=%:")
    req = urllib.request.Request(url, data=body)
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read(), resp.headers
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read(), exc.headers


def token_from(html: str) -> str:
    match = CSRF_RE.search(html)
    return match.group(1) if match else ""


def login(opener, username: str, password: str) -> bool:
    _, html, _ = fetch(opener, "/Login.aspx")
    token = token_from(html.decode("utf-8", "replace"))
    status, _, _ = fetch(opener, "/Login.aspx",
                         {"_csrf": token, "Login": username, "Pass": password})
    return status in (301, 302)


def create_user(admin_op, username: str, password: str, role: str) -> None:
    _, html, _ = fetch(admin_op, "/admin/users/")
    token = token_from(html.decode("utf-8", "replace"))
    fetch(admin_op, "/admin/users/create",
          {"_csrf": token, "username": username, "password": password, "role": role})


def cleanup() -> None:
    conn = sqlite3.connect(DB_PATH)
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.commit()
    conn.close()


def main() -> int:
    cleanup()

    # ---------------- аноним
    anonymous = make_opener()
    status, _, headers = fetch(anonymous, "/Webnav.aspx")
    check("аноним: /Webnav.aspx → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")
    status, _, headers = fetch(anonymous, "/NastroykaOPT.htm")
    check("аноним: /NastroykaOPT.htm → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    for path, markers in PAGES.items():
        status, body, _ = fetch(viewer_op, path)
        html = body.decode("utf-8", "replace")
        missing = [m for m in markers if m not in html]
        check(f"viewer: {path} → 200 и содержимое на месте",
              status == 200 and not missing,
              f"status={status}" + (f", нет: {missing}" if missing else ""))

    # ---------------- admin
    for path, markers in PAGES.items():
        status, body, _ = fetch(admin_op, path)
        html = body.decode("utf-8", "replace")
        check(f"admin: {path} → 200 и та же страница",
              status == 200 and all(marker in html for marker in markers),
              f"status={status}")

    # ---------------- готовые .htm
    for path, (charset, marker) in HTM_FILES.items():
        status, body, headers = fetch(viewer_op, path)
        content_type = headers.get("Content-Type") or ""
        text = body.decode(charset, "replace")
        check(f"viewer: {path} → 200 ({len(body)} байт)",
              status == 200 and len(body) > 1000, f"status={status}")
        check(f"{path}: кодировка {charset} в заголовке",
              charset in content_type, content_type)
        check(f"{path}: текст читается без кракозябр", marker in text)

    # ---------------- картинки и ресурсы
    status, body, _ = fetch(viewer_op, "/images/T51.jpg")
    check("/images/T51.jpg → 200 (картинка Zebra)",
          status == 200 and body[:2] == b"\xff\xd8", f"status={status}")

    status, body, _ = fetch(viewer_op, "/images/Symbolfoto/1-1.jpg")
    check("/images/Symbolfoto/1-1.jpg → 200 (сканеры Symbol)",
          status == 200 and body[:2] == b"\xff\xd8", f"status={status}")

    status, body, _ = fetch(viewer_op, "/NastroykaOPT.files/image001.png")
    check("/NastroykaOPT.files/image001.png → 200 (PNG)",
          status == 200 and body[:4] == b"\x89PNG", f"status={status}")

    status, body, _ = fetch(viewer_op, "/birka_akp5.files/image002.jpg")
    check("/birka_akp5.files/image002.jpg → 200 (JPG)",
          status == 200 and body[:2] == b"\xff\xd8", f"status={status}")

    status, body, _ = fetch(
        viewer_op,
        "/" + urllib.parse.quote("Инструкция по перезапуску WinCC.files/image001.png"))
    check("Инструкция … WinCC.files/image001.png → 200",
          status == 200 and body[:4] == b"\x89PNG", f"status={status}")

    status, body, _ = fetch(viewer_op, "/NastroykaOPT.files/filelist.xml")
    check("/NastroykaOPT.files/filelist.xml → 200",
          status == 200 and len(body) > 0, f"status={status}")

    # editdata.mso упоминается в .htm, но отсутствует и в оригинале — 404 ожидаем.
    status, _, _ = fetch(viewer_op, "/NastroykaOPT.files/editdata.mso")
    check("отсутствующий в оригинале editdata.mso → 404", status == 404,
          f"status={status}")

    # ---------------- белый список и безопасность
    status, _, _ = fetch(viewer_op, "/iisstart.htm")
    check("отладочный /iisstart.htm не перенесён → 404", status == 404,
          f"status={status}")

    status, _, _ = fetch(viewer_op, "/run.py.htm")
    check("посторонний .htm → 404", status == 404, f"status={status}")

    status, _, _ = fetch(viewer_op, "/App_Data.files/asutp.db")
    check("посторонняя папка *.files → 404", status == 404, f"status={status}")

    status, _, _ = fetch(viewer_op, "/NastroykaOPT.files/..%2f..%2frun.py")
    check("выход из папки ресурсов (..) → 404", status == 404, f"status={status}")

    status, _, _ = fetch(
        viewer_op, "/NastroykaOPT.files/" + urllib.parse.quote("нет-такого.png"))
    check("несуществующий ресурс → 404", status == 404, f"status={status}")

    # ---------------- ссылка на несуществующую инструкцию (как в оригинале)
    status, _, _ = fetch(viewer_op, "/" + urllib.parse.quote("Настройка ODBC.htm"))
    check("«Настройка ODBC» отсутствует и в оригинале → 404", status == 404,
          f"status={status}")

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
