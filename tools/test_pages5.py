"""Сквозной тест раздела «ТЭСЦ 5» (Этап 4, партия 2).

Проверяет /IpaddrT5.aspx, /Addipt5.aspx, /Editipt5.aspx:
права ролей, добавление/изменение/удаление, дубликаты, валидацию, CSRF.

Запуск (при работающем сервере):  python tools/test_pages5.py
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

TEST_KE = "TEST-T5-KE-001"

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
    conn.execute('DELETE FROM "IPaddress5" WHERE "KE" = ?', (TEST_KE,))
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


def payload(token: str, ke: str = TEST_KE, oc: str = "3") -> dict:
    return {
        "_csrf": token,
        "Uchastok": "ТЕСТ-УЧАСТОК-5",
        "Oc": oc,
        "IPaddress": "10.5.0.1",
        "MAC": "11-22-33-44-55-66",
        "KE": ke,
        "ConfigLogin": "t5-login",
        "Telephon": "55-55-55",
        "Monitor": "",
        "Printer": "",
        "UPS": "",
        "Modem": "",
        "CISCO": "",
        "Opisanie": "ТЭСЦ 5 тестовая запись",
    }


def main() -> int:
    cleanup()

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, "/IpaddrT5.aspx")
    check("viewer: /IpaddrT5.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок страницы", "Информация об АРМ ТЭСЦ 5" in html)
    check("viewer: нет кнопки «Добавить»", ">Добавить<" not in html)
    check("viewer: нет ссылок редактирования", "/Editipt5.aspx?id=" not in html)

    status, _, _ = fetch(viewer_op, "/Addipt5.aspx")
    check("viewer: /Addipt5.aspx → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/Editipt5.aspx?id=1")
    check("viewer: /Editipt5.aspx → 403", status == 403, f"status={status}")

    # ---------------- editor
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    status, html, _ = fetch(editor_op, "/IpaddrT5.aspx")
    check("editor: /IpaddrT5.aspx → 200", status == 200, f"status={status}")
    check("editor: есть кнопка «Добавить»", ">Добавить<" in html)
    check("editor: есть ссылки редактирования", "/Editipt5.aspx?id=" in html)
    check("editor: группа участка отрисована", "group-uchastok5" in html)

    status, html, _ = fetch(editor_op, "/Addipt5.aspx")
    check("editor: /Addipt5.aspx → 200", status == 200 and "Добавление данных" in html)
    token = token_from(html)

    # CSRF
    no_csrf = payload(token)
    no_csrf.pop("_csrf")
    status, _, _ = fetch(editor_op, "/Addipt5.aspx", no_csrf)
    check("POST без CSRF → 400", status == 400, f"status={status}")

    # Валидация «Ось»
    status, html, _ = fetch(editor_op, "/Addipt5.aspx", payload(token, oc=""))
    check("Пустая ось → «Неправильный формат данных»",
          status == 200 and "Неправильный формат данных" in html)
    status, html, _ = fetch(editor_op, "/Addipt5.aspx", payload(token, oc="abc"))
    check("Нечисловая ось → «Должно быть число»",
          status == 200 and "Должно быть число" in html)
    status, html, _ = fetch(editor_op, "/Addipt5.aspx", payload(token, oc="10001"))
    check("Ось вне диапазона → «Должно быть число»",
          status == 200 and "Должно быть число" in html)

    # Добавление
    status, _, _ = fetch(editor_op, "/Addipt5.aspx", payload(token))
    check("Добавление записи → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddress5" WHERE "KE" = ?', (TEST_KE,)).fetchone()
    check("Запись сохранена в БД", row is not None)
    check("Поля сохранены верно",
          row is not None and row["Uchastok"] == "ТЕСТ-УЧАСТОК-5"
          and row["Oc"] == 3 and row["Opisanie"] == "ТЭСЦ 5 тестовая запись")
    row_id = row["IDPC"] if row else None
    conn.close()

    status, html, _ = fetch(editor_op, "/IpaddrT5.aspx")
    check("Новая запись видна в списке", TEST_KE in html)

    # Редактирование
    status, html, _ = fetch(editor_op, f"/Editipt5.aspx?id={row_id}")
    check("Форма редактирования заполнена",
          status == 200 and "Редактирование данных" in html and TEST_KE in html)
    token = token_from(html)

    upd = payload(token)
    upd["IPaddress"] = "10.5.9.9"
    upd["Opisanie"] = "изменённое описание ТЭСЦ 5"
    status, _, _ = fetch(editor_op, f"/Editipt5.aspx?id={row_id}", upd)
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddress5" WHERE "IDPC" = ?', (row_id,)).fetchone()
    check("Изменения записаны", row["IPaddress"] == "10.5.9.9"
          and row["Opisanie"] == "изменённое описание ТЭСЦ 5")
    conn.close()

    # Дубликат КЕ — особый текст оригинала для этой страницы
    status, html, _ = fetch(editor_op, "/Addipt5.aspx")
    token = token_from(html)
    status, html, _ = fetch(editor_op, "/Addipt5.aspx", payload(token))
    check("Дубликат КЕ → предупреждение", status == 200 and "уже существует" in html)
    check("Дубликат КЕ → текст оригинала «Братюня…»",
          "Братюня, КЕ с таким номером уже существует" in html)
    check("Дубликат КЕ → кнопка «Все равно сохранить»",
          "Все равно сохранить" in html)

    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddress5" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("Без подтверждения дубликат не добавлен", count == 1, f"count={count}")

    force = payload(token)
    force["force"] = "1"
    status, _, _ = fetch(editor_op, "/Addipt5.aspx", force)
    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddress5" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("«Все равно сохранить» добавляет запись", count == 2, f"count={count}")

    # Удаление
    conn = db()
    ids = [r["IDPC"] for r in conn.execute(
        'SELECT "IDPC" FROM "IPaddress5" WHERE "KE" = ?', (TEST_KE,))]
    conn.close()

    for rid in ids:
        _, html, _ = fetch(editor_op, f"/Editipt5.aspx?id={rid}")
        token = token_from(html)
        status, _, _ = fetch(editor_op, f"/Editipt5.aspx?id={rid}",
                             {"_csrf": token, "action": "delete"})
        check(f"Удаление записи №{rid} → редирект", status in (301, 302),
              f"status={status}")

    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "IPaddress5" WHERE "KE" = ?',
                        (TEST_KE,)).fetchone()[0]
    total = conn.execute('SELECT COUNT(*) FROM "IPaddress5"').fetchone()[0]
    conn.close()
    check("Тестовые записи удалены", left == 0, f"left={left}")
    check("Количество строк IPaddress5 = 384", total == 384, f"total={total}")

    status, _, _ = fetch(editor_op, "/Editipt5.aspx?id=999999")
    check("Несуществующая запись → 404", status == 404, f"status={status}")

    status, _, _ = fetch(viewer_op, "/Addipt5.aspx", payload("x"))
    check("viewer: POST добавления → 403", status == 403, f"status={status}")

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
