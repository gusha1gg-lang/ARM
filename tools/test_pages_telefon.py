"""Сквозной тест раздела «Телефоны» (Этап 4, партия 6).

Проверяет /telefon.aspx: права ролей, список, сортировку по заголовкам,
добавление, изменение, удаление, CSRF.

Запуск (при работающем сервере):  python tools/test_pages_telefon.py
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
TEST_FIO = "ТЕСТ-ТЕЛЕФОН Тестович"

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


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.execute('DELETE FROM "telefon" WHERE "fio" LIKE ?', ("ТЕСТ-ТЕЛЕФОН%",))
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

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, "/telefon.aspx")
    check("viewer: /telefon.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок «Список телефонов»", "Список телефонов" in html)
    check("viewer: колонки ФИО и Телефон",
          ">ФИО</a>" in html and ">Телефон</a>" in html)
    check("viewer: нет формы добавления", 'name="action" value="add"' not in html)
    check("viewer: нет кнопок «Изменить»/«Удалить»",
          ">Изменить</a>" not in html and ">Удалить</button>" not in html)

    _, html, _ = fetch(viewer_op, "/telefon.aspx")
    token = token_from(html)
    status, _, _ = fetch(viewer_op, "/telefon.aspx",
                         {"_csrf": token, "action": "add", "fio": "X", "telnumber": "1"})
    check("viewer: POST добавления → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/telefon.aspx",
                         {"_csrf": token, "action": "delete", "id": "1"})
    check("viewer: POST удаления → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/telefon.aspx?edit=1")
    check("viewer: edit игнорируется (нет формы правки)",
          status == 200 and 'id="edit-form"' not in html)

    # ---------------- список и сортировка (admin)
    conn = db()
    total = conn.execute('SELECT COUNT(*) FROM "telefon"').fetchone()[0]
    order_default = [r["fio"] for r in conn.execute('SELECT "fio" FROM "telefon"')]
    order_fio = [r["fio"] for r in conn.execute('SELECT "fio" FROM "telefon" ORDER BY "fio" ASC')]
    order_tel = [r["fio"] for r in conn.execute(
        'SELECT "fio" FROM "telefon" ORDER BY "telnumber" DESC')]
    conn.close()

    status, html, _ = fetch(admin_op, "/telefon.aspx")
    check("admin: /telefon.aspx → 200", status == 200, f"status={status}")
    check(f"admin: {total} строк в списке",
          html.count('<tr class="row-') == total, f"rows={html.count('<tr class=\"row-')}")
    check("admin: порядок по умолчанию — как в БД (без ORDER BY)",
          html.index(order_default[0]) < html.index(order_default[1]))
    check("admin: есть форма добавления и кнопки правки", 'name="action" value="add"' in html
          and ">Изменить</a>" in html and ">Удалить</button>" in html)

    status, html, _ = fetch(admin_op, "/telefon.aspx?sort=fio&dir=asc")
    check("сортировка ФИО по возрастанию",
          status == 200 and html.index(order_fio[0]) < html.index(order_fio[1]))
    status, html, _ = fetch(admin_op, "/telefon.aspx?sort=fio&dir=desc")
    check("сортировка ФИО по убыванию",
          status == 200 and html.index(order_fio[-1]) < html.index(order_fio[-2]))
    status, html, _ = fetch(admin_op, "/telefon.aspx?sort=telnumber&dir=desc")
    check("сортировка Телефон по убыванию",
          status == 200 and html.index(order_tel[0]) < html.index(order_tel[1]))
    status, html, _ = fetch(admin_op, "/telefon.aspx?sort=zzz&dir=zzz")
    check("некорректная сортировка → порядок по умолчанию",
          status == 200 and html.index(order_default[0]) < html.index(order_default[1]))

    # ---------------- editor: добавление
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    _, html, _ = fetch(editor_op, "/telefon.aspx")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/telefon.aspx",
                         {"fio": TEST_FIO, "telnumber": "12345", "action": "add"})
    check("POST без CSRF → 400", status == 400, f"status={status}")

    status, _, _ = fetch(editor_op, "/telefon.aspx",
                         {"_csrf": token, "action": "add", "fio": TEST_FIO,
                          "telnumber": "12345"})
    check("Добавление → редирект", status in (301, 302), f"status={status}")
    _, html, _ = fetch(editor_op, "/telefon.aspx")
    check("Добавление → сообщение и новая строка",
          "Запись добавлена." in html and TEST_FIO in html)

    conn = db()
    row = conn.execute('SELECT * FROM "telefon" WHERE "fio" = ?', (TEST_FIO,)).fetchone()
    check("Запись в БД с верными полями",
          row is not None and row["telnumber"] == "12345")
    row_id = row["id"] if row else None
    total2 = conn.execute('SELECT COUNT(*) FROM "telefon"').fetchone()[0]
    conn.close()
    check(f"Количество строк telefon = {total + 1}", total2 == total + 1,
          f"total={total2}")

    # ---------------- editor: изменение
    status, html, _ = fetch(editor_op, f"/telefon.aspx?edit={row_id}")
    check("Строка открыта на редактирование",
          status == 200 and 'id="edit-form"' in html and TEST_FIO in html)
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/telefon.aspx",
                         {"_csrf": token, "action": "update", "id": str(row_id),
                          "fio": TEST_FIO + " Изменённый", "telnumber": "54321"})
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")
    conn = db()
    row = conn.execute('SELECT * FROM "telefon" WHERE "id" = ?', (row_id,)).fetchone()
    conn.close()
    check("Изменения записаны",
          row["fio"] == TEST_FIO + " Изменённый" and row["telnumber"] == "54321")

    # ---------------- удаление и ошибки
    status, _, _ = fetch(editor_op, "/telefon.aspx",
                         {"_csrf": token, "action": "delete", "id": str(row_id)})
    check("Удаление → редирект", status in (301, 302), f"status={status}")
    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "telefon" WHERE "fio" LIKE ?',
                        ("ТЕСТ-ТЕЛЕФОН%",)).fetchone()[0]
    total3 = conn.execute('SELECT COUNT(*) FROM "telefon"').fetchone()[0]
    conn.close()
    check("Тестовая запись удалена", left == 0, f"left={left}")
    check(f"Количество строк telefon = {total}", total3 == total, f"total={total3}")

    status, _, _ = fetch(editor_op, "/telefon.aspx",
                         {"_csrf": token, "action": "delete", "id": "abc"})
    check("Некорректный id → 400", status == 400, f"status={status}")
    status, html, _ = fetch(editor_op, "/telefon.aspx?edit=999999")
    check("Несуществующий edit → без формы правки",
          status == 200 and 'id="edit-form"' not in html)

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
