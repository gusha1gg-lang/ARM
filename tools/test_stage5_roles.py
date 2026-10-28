"""Этап 5: матрица доступа ко всем страницам под каждой ролью.

Прогоняет все реализованные страницы под тремя ролями (viewer / editor / admin)
и проверяет:
  * аноним получает редирект на вход;
  * все страницы чтения открываются всем ролям;
  * формы добавления/правки доступны editor и admin, viewer получает 403;
  * запись (POST) для viewer запрещена на всех разделах;
  * у viewer в списках нет кнопок добавления/правки/удаления;
  * управление пользователями доступно только admin.

Запуск (при работающем сервере):  python tools/test_stage5_roles.py
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

#: Страницы только для чтения — доступны всем ролям.
READ_PAGES = [
    "/main.aspx",
    "/IpaddrT5.aspx",
    "/IPaddrUch.aspx",
    "/IPaddrALL.aspx",
    "/JR.aspx",
    "/VideoIP.aspx?VideoType=IP",
    "/VideoIP.aspx?VideoType=Analog",
    "/VideoAnalog.aspx",
    "/telefon.aspx",
    "/CISCO.aspx",
    "/CISCO2.aspx",
    "/ReportExist.aspx?KE=1234",
    "/SPR_CISCO.aspx?SPRType=1",
    "/SPR_CISCO.aspx?SPRType=2",
    "/spr_shop.aspx",
    "/Webnav.aspx",
    "/NastoikaT5.aspx",
    "/NastoikaEBS.aspx",
    "/Calendar.aspx",
    "/Logs.aspx",
    "/NastroykaOPT.htm",
    "/birka_akp5.htm",
    "/tururushka.htm",
    "/Инструкция по перезапуску WinCC.htm",
]

#: Формы добавления/правки — editor и admin.
FORM_PAGES = [
    "/Addipt4.aspx",
    "/Edit.aspx?id=1",
    "/Addipt5.aspx",
    "/Editipt5.aspx?id=1",
    "/Addipuch.aspx",
    "/EditUch.aspx?id=14",
    "/AddipALL.aspx",
    "/EditALL.aspx?id=1",
    "/AddJR.aspx",
    "/EditJR.aspx?id=1",
]

#: У viewer не должно быть этих признаков правки на страницах списков.
NO_EDIT_MARKERS = {
    "/main.aspx": (">Добавить<", "/Edit.aspx?id="),
    "/IpaddrT5.aspx": (">Добавить<", "/Editipt5.aspx?id="),
    "/IPaddrUch.aspx": (">Добавить<", "/EditUch.aspx?id="),
    "/IPaddrALL.aspx": (">Добавить<", "/EditALL.aspx?id="),
    "/JR.aspx": ("/AddJR.aspx", "/EditJR.aspx"),
    "/SPR_CISCO.aspx?SPRType=1": ("/img/buttonedit.png", "/img/cross.png",
                                 "/img/cross_edit_add32.png"),
    "/SPR_CISCO.aspx?SPRType=2": ("/img/buttonedit.png", "/img/cross.png",
                                 "/img/cross_edit_add32.png"),
    "/spr_shop.aspx": ('name="action" value="insert"', "/img/buttonedit.png"),
    "/telefon.aspx": ('name="action" value="add"',),
    "/VideoIP.aspx?VideoType=IP": ("Добавить камеру", "edit=",
                                  'name="action" value="delete"'),
    "/VideoIP.aspx?VideoType=Analog": ("Добавить камеру", "edit=",
                                      'name="action" value="delete"'),
}

#: POST-адреса разделов: viewer должен получать 403.
WRITE_ENDPOINTS = [
    "/Addipt4.aspx",
    "/Addipt5.aspx",
    "/Addipuch.aspx",
    "/AddipALL.aspx",
    "/AddJR.aspx",
    "/SPR_CISCO.aspx?SPRType=1",
    "/SPR_CISCO.aspx?SPRType=2",
    "/spr_shop.aspx",
    "/telefon.aspx",
    "/VideoIP/upload",
]

results = []


def check(name: str, ok: bool, extra: str = "") -> None:
    results.append((name, ok, extra))
    if not ok:
        print(f"FAIL {name}{(' - ' + extra) if extra else ''}")


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
    url = BASE + urllib.parse.quote(path, safe="/?&=%:")
    req = urllib.request.Request(url, data=body)
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read().decode("utf-8", "replace"), resp.headers
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace"), exc.headers


def token_from(html: str) -> str:
    match = CSRF_RE.search(html)
    return match.group(1) if match else ""


def login(opener, username: str, password: str) -> bool:
    _, html, _ = fetch(opener, "/Login.aspx")
    status, _, _ = fetch(opener, "/Login.aspx",
                         {"_csrf": token_from(html), "Login": username, "Pass": password})
    return status in (301, 302)


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.execute(
        "DELETE FROM audit_log WHERE username IN ('test_editor','test_viewer') "
        "OR details LIKE '%test_editor%' OR details LIKE '%test_viewer%'"
    )
    conn.commit()
    conn.close()


def create_user(admin_op, username: str, password: str, role: str) -> None:
    _, html, _ = fetch(admin_op, "/admin/users/")
    fetch(admin_op, "/admin/users/create",
          {"_csrf": token_from(html), "username": username,
           "password": password, "role": role})


def main() -> int:
    cleanup()

    # ---------------- аноним
    anonymous = make_opener()
    status, html, _ = fetch(anonymous, "/Login.aspx")
    check("аноним: /Login.aspx → 200", status == 200, f"status={status}")
    for path in READ_PAGES + FORM_PAGES + ["/admin/users/"]:
        status, _, headers = fetch(anonymous, path)
        check(f"аноним: {path} → редирект на вход",
              status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
              f"status={status}")

    # ---------------- учётные записи
    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    editor_op = make_opener()
    check("Вход editor", login(editor_op, "test_editor", "editor123"))
    viewer_op = make_opener()
    check("Вход viewer", login(viewer_op, "test_viewer", "viewer123"))

    role_ops = {"viewer": viewer_op, "editor": editor_op, "admin": admin_op}

    # ---------------- чтение под всеми ролями
    for role, op in role_ops.items():
        for path in READ_PAGES:
            status, html, _ = fetch(op, path)
            ok = (status == 200 and "Traceback" not in html
                  and "Внутренняя ошибка" not in html)
            check(f"{role}: {path} → 200", ok, f"status={status}")

    # ---------------- формы под ролями
    for path in FORM_PAGES:
        status, _, _ = fetch(viewer_op, path)
        check(f"viewer: {path} → 403", status == 403, f"status={status}")
        for role in ("editor", "admin"):
            status, html, _ = fetch(role_ops[role], path)
            check(f"{role}: {path} → 200", status == 200, f"status={status}")

    # ---------------- запись для viewer запрещена
    for path in WRITE_ENDPOINTS:
        status, _, _ = fetch(viewer_op, path, {"_csrf": "x", "action": "insert"})
        check(f"viewer: POST {path} → 403", status == 403, f"status={status}")

    # ---------------- у viewer нет кнопок правки
    for path, markers in NO_EDIT_MARKERS.items():
        _, html, _ = fetch(viewer_op, path)
        found = [marker for marker in markers if marker in html]
        check(f"viewer: {path} без кнопок правки", not found,
              f"найдено: {found}")

    # ---------------- у editor кнопки правки есть
    for path in ("/main.aspx", "/JR.aspx", "/SPR_CISCO.aspx?SPRType=1",
                 "/spr_shop.aspx", "/telefon.aspx",
                 "/VideoIP.aspx?VideoType=IP"):
        _, html, _ = fetch(editor_op, path)
        check(f"editor: {path} с кнопками правки",
              "/img/buttonedit.png" in html or ">Добавить<" in html
              or "Редактировать" in html or "Добавить камеру" in html
              or "/AddJR.aspx" in html or 'name="action" value="insert"' in html)

    # ---------------- управление пользователями
    status, html, _ = fetch(admin_op, "/admin/users/")
    check("admin: /admin/users/ → 200, список и роли",
          status == 200 and "Пользователи" in html and "viewer" in html
          and "editor" in html and "admin" in html, f"status={status}")
    for role in ("viewer", "editor"):
        status, _, _ = fetch(role_ops[role], "/admin/users/")
        check(f"{role}: /admin/users/ → 403", status == 403, f"status={status}")
        status, _, _ = fetch(role_ops[role], "/admin/users/create",
                             {"_csrf": "x", "username": "x", "password": "xxxxxx",
                              "role": "admin"})
        check(f"{role}: POST /admin/users/create → 403", status == 403,
              f"status={status}")

    cleanup()
    failed = [r for r in results if not r[1]]
    print()
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    print("Матрица: страниц чтения — %d, форм — %d, POST-точек — %d, ролей — 3."
          % (len(READ_PAGES), len(FORM_PAGES), len(WRITE_ENDPOINTS)))
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
