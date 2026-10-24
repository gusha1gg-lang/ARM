"""Сквозной тест раздела CISCO (Этап 4, партия 7).

Проверяет /CISCO.aspx и /CISCO2.aspx: доступ после входа, заголовки,
перенесённые статические таблицы (1-в-1 из Excel-экспорта).

Запуск (при работающем сервере):  python tools/test_pages_cisco.py
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
    req = urllib.request.Request(BASE + path, data=body)
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read().decode("utf-8", "replace"), resp.headers
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace"), exc.headers


def token_from(html: str) -> str:
    m = CSRF_RE.search(html)
    return m.group(1) if m else ""


def cleanup() -> None:
    conn = sqlite3.connect(DB_PATH)
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.commit()
    conn.close()


def login(opener, username: str, password: str) -> bool:
    _, html, _ = fetch(opener, "/Login.aspx")
    token = token_from(html)
    status, _, _ = fetch(opener, "/Login.aspx",
                         {"_csrf": token, "Login": username, "Pass": password})
    return status in (301, 302)


def create_user(admin_op, username: str, password: str, role: str) -> None:
    _, html, _ = fetch(admin_op, "/admin/users/")
    token = token_from(html)
    fetch(admin_op, "/admin/users/create",
          {"_csrf": token, "username": username, "password": password, "role": role})


def main() -> int:
    cleanup()

    anonymous = make_opener()
    status, _, headers = fetch(anonymous, "/CISCO.aspx")
    check("аноним: /CISCO.aspx → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, "/CISCO.aspx")
    check("viewer: /CISCO.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок «Таблица запитки коммутационных шкафов ТЭСЦ-4»",
          "Таблица запитки коммутационных шкафов ТЭСЦ-4" in html)
    check("viewer: таблица и данные перенесены",
          "MsoNormalTable" in html and "УАПТ" in html and "4_1" in html)
    check("viewer: шапка с колонками",
          "№ шкафа" in html and "Место установки" in html
          and "Расположение по осям" in html)
    check("viewer: меню CISCO на месте",
          ">Шкафы</a>" in html and ">Узлы ВМЗ</a>" in html)

    status, html, _ = fetch(viewer_op, "/CISCO2.aspx")
    check("viewer: /CISCO2.aspx → 200", status == 200, f"status={status}")
    # В оригинале заголовок разбит на строки — сравниваем без учёта пробелов.
    flat = " ".join(html.split())
    check("viewer: заголовок «Список критичных узлов ВМЗ»",
          "Список критичных узлов ВМЗ" in flat)
    check("viewer: колонки узлов",
          "№ узла" in html and "Название узла" in html and "Доступность" in html)
    check("viewer: данные узлов перенесены",
          "ТЭСЦ-2 (отгрузка)" in html)

    status, html, _ = fetch(admin_op, "/CISCO.aspx")
    check("admin: /CISCO.aspx → 200 и та же таблица",
          status == 200 and "MsoNormalTable" in html)
    status, html, _ = fetch(admin_op, "/CISCO2.aspx")
    check("admin: /CISCO2.aspx → 200 и та же таблица",
          status == 200 and "Список критичных узлов ВМЗ" in " ".join(html.split()))

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
