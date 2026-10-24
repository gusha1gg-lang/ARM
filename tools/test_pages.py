"""Сквозной тест раздела «ТЭСК ТБД» (Этап 4, партия 1).

Проверяет /main.aspx, /Addipt4.aspx, /Edit.aspx, /ReportExist.aspx:
права ролей, фильтр по пролёту, добавление/изменение/удаление,
проверку дубликатов, валидацию и CSRF.

Запуск (при работающем сервере):  python tools/test_pages.py
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

TEST_KE = "TEST-KE-001"
TEST_KE_2 = "TEST-KE-002"

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
    url = BASE + path
    body = urllib.parse.urlencode(data).encode() if data is not None else None
    req = urllib.request.Request(url, data=body)
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
    conn.execute('DELETE FROM "IPaddress4" WHERE "KE" IN (?, ?)', (TEST_KE, TEST_KE_2))
    conn.commit()
    conn.close()


def login(opener, username: str, password: str) -> bool:
    status, html, _ = fetch(opener, "/Login.aspx")
    token = token_from(html)
    status, _, _ = fetch(opener, "/Login.aspx",
                         {"_csrf": token, "Login": username, "Pass": password})
    return status in (301, 302)


def create_user(admin_op, username: str, password: str, role: str) -> None:
    status, html, _ = fetch(admin_op, "/admin/users/")
    token = token_from(html)
    fetch(admin_op, "/admin/users/create",
          {"_csrf": token, "username": username, "password": password, "role": role})


def form_payload(token: str, ke: str, ip: str = "10.0.0.1") -> dict:
    return {
        "_csrf": token,
        "Prolet": "7",
        "Uchastok": "ТЕСТ-УЧАСТОК",
        "AgeregatName": "TEST-AGG",
        "Oc": "1",
        "ConfigLogin": "test-login",
        "IPaddress": ip,
        "Shluz": "10.0.0.254",
        "MAC": "AA-BB-CC-DD-EE-FF",
        "KE": ke,
        "Telephon": "123-45-67",
        "Monitor": "",
        "Printer": "",
        "UPS": "",
        "Modem": "",
        "CISCO": "",
        "Opisanie": "тестовая запись, кириллица",
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

    status, html, _ = fetch(viewer_op, "/main.aspx")
    check("viewer: /main.aspx → 200", status == 200, f"status={status}")
    check("viewer: таблица отрисована", "Информация об АРМ ТЭСК ТБД" in html)
    check("viewer: нет кнопки «Добавить»", ">Добавить<" not in html)
    check("viewer: нет ссылок редактирования", "/Edit.aspx?id=" not in html)
    check("viewer: список пролётов как в оригинале",
          "Пролет №-1 Ф-Ц" in html and "Внешний участок" in html)

    status, _, _ = fetch(viewer_op, "/Addipt4.aspx")
    check("viewer: /Addipt4.aspx → 403", status == 403, f"status={status}")

    status, _, _ = fetch(viewer_op, "/Edit.aspx?id=1")
    check("viewer: /Edit.aspx → 403", status == 403, f"status={status}")

    # ---------------- editor
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    status, html, _ = fetch(editor_op, "/main.aspx")
    check("editor: /main.aspx → 200", status == 200, f"status={status}")
    check("editor: есть кнопка «Добавить»", ">Добавить<" in html)
    check("editor: есть ссылки редактирования", "/Edit.aspx?id=" in html)

    status, html, _ = fetch(editor_op, "/Addipt4.aspx")
    check("editor: /Addipt4.aspx → 200", status == 200 and "Добавление данных" in html)
    token = token_from(html)

    # CSRF
    payload = form_payload(token, TEST_KE)
    no_csrf = dict(payload)
    no_csrf.pop("_csrf")
    status, _, _ = fetch(editor_op, "/Addipt4.aspx", no_csrf)
    check("POST без CSRF → 400", status == 400, f"status={status}")

    # Нечисловой пролёт
    bad = form_payload(token, TEST_KE)
    bad["Prolet"] = "abc"
    status, html, _ = fetch(editor_op, "/Addipt4.aspx", bad)
    check("Нечисловой пролёт → сообщение валидатора",
          status == 200 and "Номером пролета должно быть число" in html)

    # Добавление
    status, _, headers = fetch(editor_op, "/Addipt4.aspx", payload)
    check("Добавление записи → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddress4" WHERE "KE" = ?', (TEST_KE,)).fetchone()
    check("Запись сохранена в БД", row is not None)
    check("Поля сохранены верно",
          row is not None and row["Uchastok"] == "ТЕСТ-УЧАСТОК"
          and row["Opisanie"] == "тестовая запись, кириллица"
          and row["Prolet"] == 7 and row["Oc"] == 1)
    row_id = row["IDPC"] if row else None
    conn.close()

    status, html, _ = fetch(editor_op, "/main.aspx")
    check("Новая запись видна в списке", TEST_KE in html)
    check("Заголовок пролёта отрисован", "Пролет №: 7" in html)

    # Фильтр по пролёту
    status, html, _ = fetch(editor_op, "/main.aspx?prolet=7")
    check("Фильтр по пролёту → 200", status == 200 and "Пролет №: 7" in html)
    status, html, _ = fetch(editor_op, "/main.aspx?prolet=1")
    check("Фильтр исключает другие пролёты",
          status == 200 and "Пролет №: 7" not in html)
    status, html, _ = fetch(editor_op, "/main.aspx?prolet=zzz")
    check("Некорректный фильтр → «все»", status == 200 and "Пролет №: 7" in html)

    # Редактирование
    status, html, _ = fetch(editor_op, f"/Edit.aspx?id={row_id}")
    check("Форма редактирования заполнена",
          status == 200 and "Редактирование данных" in html and TEST_KE in html)
    token = token_from(html)

    upd = form_payload(token, TEST_KE, ip="10.9.9.9")
    upd["Opisanie"] = "изменённое описание"
    status, _, _ = fetch(editor_op, f"/Edit.aspx?id={row_id}", upd)
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddress4" WHERE "IDPC" = ?', (row_id,)).fetchone()
    check("Изменения записаны", row["IPaddress"] == "10.9.9.9"
          and row["Opisanie"] == "изменённое описание")
    conn.close()

    # Дубликат КЕ
    status, html, _ = fetch(editor_op, "/Addipt4.aspx")
    token = token_from(html)
    status, html, _ = fetch(editor_op, "/Addipt4.aspx", form_payload(token, TEST_KE))
    check("Дубликат КЕ → предупреждение",
          status == 200 and "уже существует" in html)
    check("Дубликат КЕ → кнопка «Все равно сохранить»",
          "Все равно сохранить" in html)

    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddress4" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("Без подтверждения дубликат не добавлен", count == 1, f"count={count}")

    # Принудительное сохранение
    force = form_payload(token, TEST_KE)
    force["force"] = "1"
    status, _, _ = fetch(editor_op, "/Addipt4.aspx", force)
    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddress4" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("«Все равно сохранить» добавляет запись", count == 2, f"count={count}")

    # Поиск КЕ
    status, html, _ = fetch(editor_op, f"/ReportExist.aspx?KE={TEST_KE}")
    check("Поиск КЕ находит записи", status == 200 and TEST_KE in html)
    status, html, _ = fetch(editor_op, "/ReportExist.aspx?KE=NOPE-404")
    check("Поиск без совпадений → сообщение",
          status == 200 and "ничего не найдено" in html)

    # Удаление обеих тестовых записей
    conn = db()
    ids = [r["IDPC"] for r in conn.execute(
        'SELECT "IDPC" FROM "IPaddress4" WHERE "KE" = ?', (TEST_KE,))]
    conn.close()

    for rid in ids:
        status, html, _ = fetch(editor_op, f"/Edit.aspx?id={rid}")
        token = token_from(html)
        status, _, _ = fetch(editor_op, f"/Edit.aspx?id={rid}",
                             {"_csrf": token, "action": "delete"})
        check(f"Удаление записи №{rid} → редирект", status in (301, 302),
              f"status={status}")

    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "IPaddress4" WHERE "KE" = ?',
                        (TEST_KE,)).fetchone()[0]
    conn.close()
    check("Тестовые записи удалены", left == 0, f"left={left}")

    status, _, _ = fetch(editor_op, "/Edit.aspx?id=999999")
    check("Несуществующая запись → 404", status == 404, f"status={status}")

    # viewer не может отправлять формы
    status, html, _ = fetch(viewer_op, "/main.aspx")
    token = token_from(html)
    status, _, _ = fetch(viewer_op, "/Addipt4.aspx", form_payload(token, "TEST-KE-HACK"))
    check("viewer: POST добавления → 403", status == 403, f"status={status}")

    # ---------------- итог
    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
