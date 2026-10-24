"""Сквозной тест раздела «Ярлыки» (Этап 4, партия 8).

Проверяет /JR.aspx, /AddJR.aspx, /EditJR.aspx?id=N и скачивание файлов
из Slegenie/: права ролей, список, добавление, изменение, удаление, CSRF.

Запуск (при работающем сервере):  python tools/test_pages_jr.py
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
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(ROOT, "instance", "asutp.db")

TEST_NAME = "ТЕСТ-ЯРЛЫК"
TEST_FILE = "ТЕСТ-ЯРЛЫК.lnk"

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


def fetch_raw(opener, path):
    req = urllib.request.Request(BASE + path)
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read(), resp.headers
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read(), exc.headers


def token_from(html: str) -> str:
    match = CSRF_RE.search(html)
    return match.group(1) if match else ""


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.execute('DELETE FROM "Jarlik" WHERE "NameJarlik" LIKE ?', ("ТЕСТ-ЯРЛЫК%",))
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

    conn = db()
    total = conn.execute('SELECT COUNT(*) FROM "Jarlik"').fetchone()[0]
    first = conn.execute('SELECT * FROM "Jarlik" ORDER BY "IDJarlik" LIMIT 1').fetchone()
    order = [r["NameJarlik"] for r in conn.execute('SELECT "NameJarlik" FROM "Jarlik"')]
    conn.close()

    # ---------------- аноним
    anonymous = make_opener()
    status, _, headers = fetch(anonymous, "/JR.aspx")
    check("аноним: /JR.aspx → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, "/JR.aspx")
    check("viewer: /JR.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок «Список ярлыков»", "Список ярлыков" in html)
    check(f"viewer: {total} строк в таблице",
          html.count('class="table--jarlik__name"') == total,
          f"rows={html.count('class=\"table--jarlik__name\"')}")
    check("viewer: нет кнопки «Добавить»", ">Добавить</a>" not in html)
    check("viewer: нет ссылок редактирования", "/EditJR.aspx" not in html)
    # Сравниваем по ячейкам: имена ярлыков могут быть подстроками друг друга.
    check("viewer: порядок строк как в БД",
          html.index(f">{order[0]}<") < html.index(f">{order[1]}<"))
    check("viewer: ссылки на скачивание файлов",
          f"/Slegenie/{urllib.parse.quote(first['LnkNameJarlik'])}" in html
          or "/Slegenie/" in html)

    status, body, headers = fetch_raw(
        viewer_op, "/Slegenie/" + urllib.parse.quote(first["LnkNameJarlik"]))
    check("viewer: скачивание файла ярлыка → 200",
          status == 200 and len(body) > 0, f"status={status} size={len(body)}")
    check("viewer: файл отдаётся как вложение (attachment)",
          "attachment" in (headers.get("Content-Disposition") or ""))

    status, _, _ = fetch(viewer_op, "/AddJR.aspx")
    check("viewer: /AddJR.aspx → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, f"/EditJR.aspx?id={first['IDJarlik']}")
    check("viewer: /EditJR.aspx → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/Slegenie/" + urllib.parse.quote("нет-такого-файла.lnk"))
    check("несуществующий файл ярлыка → 404", status == 404, f"status={status}")

    # ---------------- editor: добавление
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    status, html, _ = fetch(editor_op, "/AddJR.aspx")
    check("editor: форма добавления → 200",
          status == 200 and "Добавление ярлыка" in html
          and "Название ярлыка в таблице" in html
          and "Название файла ярлыка (.lnk)" in html
          and ">Сохранить</button>" in html, f"status={status}")
    token = token_from(html)

    status, _, _ = fetch(editor_op, "/AddJR.aspx", {"NameJarlik": TEST_NAME, "LnkNameJarlik": TEST_FILE})
    check("POST без CSRF → 400", status == 400, f"status={status}")

    status, _, headers = fetch(editor_op, "/AddJR.aspx",
                               {"_csrf": token, "NameJarlik": TEST_NAME,
                                "LnkNameJarlik": TEST_FILE})
    check("Добавление → редирект на /JR.aspx",
          status in (301, 302) and "/JR.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    status, html, _ = fetch(editor_op, "/JR.aspx")
    check("Добавление → сообщение и новая строка в списке",
          "Ярлык добавлен." in html and TEST_NAME in html)

    conn = db()
    row = conn.execute('SELECT * FROM "Jarlik" WHERE "NameJarlik" = ?', (TEST_NAME,)).fetchone()
    check("Запись в БД с верными полями",
          row is not None and row["LnkNameJarlik"] == TEST_FILE)
    row_id = row["IDJarlik"] if row else None
    total2 = conn.execute('SELECT COUNT(*) FROM "Jarlik"').fetchone()[0]
    conn.close()
    check(f"Количество строк Jarlik = {total + 1}", total2 == total + 1, f"total={total2}")

    # ---------------- editor: изменение
    status, html, _ = fetch(editor_op, f"/EditJR.aspx?id={row_id}")
    check("Форма правки → 200, поля заполнены",
          status == 200 and "Редактирование или удаление ярлыка" in html
          and TEST_NAME in html and TEST_FILE in html, f"status={status}")
    check("Форма правки: кнопки «Сохранить» и «Удалить епт» (текст оригинала)",
          ">Сохранить</button>" in html and ">Удалить епт</button>" in html)
    token = token_from(html)

    changed = TEST_NAME + " изменён"
    status, _, _ = fetch(editor_op, f"/EditJR.aspx?id={row_id}",
                         {"_csrf": token, "action": "update", "NameJarlik": changed,
                          "LnkNameJarlik": TEST_FILE})
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")
    conn = db()
    row = conn.execute('SELECT * FROM "Jarlik" WHERE "IDJarlik" = ?', (row_id,)).fetchone()
    conn.close()
    check("Изменения записаны", row is not None and row["NameJarlik"] == changed)

    # ---------------- editor: удаление
    status, _, _ = fetch(editor_op, f"/EditJR.aspx?id={row_id}",
                         {"_csrf": token, "action": "delete"})
    check("Удаление → редирект", status in (301, 302), f"status={status}")
    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "Jarlik" WHERE "NameJarlik" LIKE ?',
                        ("ТЕСТ-ЯРЛЫК%",)).fetchone()[0]
    total3 = conn.execute('SELECT COUNT(*) FROM "Jarlik"').fetchone()[0]
    conn.close()
    check("Тестовая запись удалена", left == 0, f"left={left}")
    check(f"Количество строк Jarlik = {total}", total3 == total, f"total={total3}")

    # ---------------- ошибки
    status, _, _ = fetch(editor_op, "/EditJR.aspx?id=abc")
    check("Нечисловой id → 404", status == 404, f"status={status}")
    status, _, _ = fetch(editor_op, "/EditJR.aspx?id=999999")
    check("Несуществующий id → 404", status == 404, f"status={status}")
    status, _, _ = fetch(editor_op, "/EditJR.aspx")
    check("Без id → 404", status == 404, f"status={status}")
    status, _, _ = fetch(editor_op, f"/EditJR.aspx?id={first['IDJarlik']}",
                         {"_csrf": token, "action": "zzz"})
    check("Неизвестное действие → 400", status == 400, f"status={status}")

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
