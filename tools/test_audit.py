"""Сквозной тест журнала действий («Логи») и пометки последнего изменения.

Проверяет:
  * страница /Logs.aspx доступна после входа и недоступна анониму;
  * вход в систему записывается в журнал;
  * добавление, изменение и удаление записи фиксируются (кто, что, когда);
  * фильтры журнала (пользователь / раздел / действие / даты) работают;
  * на форме редактирования справа от заголовка видно, кто и когда
    последним изменял запись;
  * тестовые записи и их строки журнала удаляются по завершении.

Запуск (при работающем сервере):  python tools/test_audit.py
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

ADMIN_LOGIN = "admin"
ADMIN_PASSWORD = "11111111"
MARKER = "АУДИТ-МЕТКА"  # без «_»: символ «_» в LIKE — шаблон одного символа

passed = 0
failed = 0


def check(name: str, ok: bool, extra: str = "") -> None:
    global passed, failed
    if ok:
        passed += 1
    else:
        failed += 1
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
                         {"_csrf": token_from(html), "Login": username,
                          "Pass": password})
    return status in (301, 302)


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute('DELETE FROM "telefon" WHERE "fio" LIKE ?', (MARKER + "%",))
    conn.execute('DELETE FROM "Jarlik" WHERE "NameJarlik" LIKE ?', (MARKER + "%",))
    conn.execute('DELETE FROM "IPaddress4" WHERE "KE" LIKE ?', (MARKER + "%",))
    conn.execute('DELETE FROM "audit_log" WHERE "details" LIKE ?', ("%" + MARKER + "%",))
    conn.commit()
    conn.close()


def last_log(entity: str, record_id) -> sqlite3.Row | None:
    conn = db()
    row = conn.execute(
        'SELECT * FROM "audit_log" WHERE "entity" = ? AND "record_id" = ? '
        'ORDER BY "id" DESC LIMIT 1',
        (entity, str(record_id)),
    ).fetchone()
    conn.close()
    return row


def main() -> int:
    cleanup()

    # ------------------------------------------------ аноним
    anonymous = make_opener()
    status, _, headers = fetch(anonymous, "/Logs.aspx")
    check("аноним: /Logs.aspx → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    # ------------------------------------------------ вход и журнал входа
    admin = make_opener()
    check("вход admin", login(admin, ADMIN_LOGIN, ADMIN_PASSWORD))

    conn = db()
    login_row = conn.execute(
        'SELECT * FROM "audit_log" WHERE "action" = \'login\' '
        'AND "username" = ? ORDER BY "id" DESC LIMIT 1', (ADMIN_LOGIN,)
    ).fetchone()
    conn.close()
    check("вход записан в журнал",
          login_row is not None and login_row["entity"] == "auth",
          "нет строки login" if login_row is None else "")

    status, html, _ = fetch(admin, "/Logs.aspx")
    check("страница /Logs.aspx открывается", status == 200, f"status={status}")
    check("в меню есть пункт «Логи»", 'href="/Logs.aspx"' in html)

    # ------------------------------------------------ телефоны: add/update/delete
    _, page, _ = fetch(admin, "/telefon.aspx")
    token = token_from(page)
    fetch(admin, "/telefon.aspx",
          {"_csrf": token, "action": "add",
           "fio": MARKER + " Телефон", "telnumber": "+7 000 000-00-00"})
    conn = db()
    row = conn.execute('SELECT * FROM "telefon" WHERE "fio" = ?',
                       (MARKER + " Телефон",)).fetchone()
    conn.close()
    check("тестовая запись телефона создана", row is not None)
    if row is None:
        cleanup()
        return 1
    phone_id = row["id"]

    created = last_log("telefon", phone_id)
    check("добавление телефона записано",
          created is not None and created["action"] == "create"
          and created["username"] == ADMIN_LOGIN,
          "" if created is not None else "нет строки")

    _, page, _ = fetch(admin, "/telefon.aspx")
    token = token_from(page)
    fetch(admin, "/telefon.aspx",
          {"_csrf": token, "action": "update", "id": phone_id,
           "fio": MARKER + " Телефон (изм.)", "telnumber": "+7 111"})
    updated = last_log("telefon", phone_id)
    check("изменение телефона записано",
          updated is not None and updated["action"] == "update"
          and "(изм.)" in (updated["details"] or ""),
          "" if updated is not None else "нет строки")

    _, page, _ = fetch(admin, "/telefon.aspx")
    token = token_from(page)
    fetch(admin, "/telefon.aspx",
          {"_csrf": token, "action": "delete", "id": phone_id})
    conn = db()
    gone = conn.execute('SELECT 1 FROM "telefon" WHERE "id" = ?', (phone_id,)).fetchone()
    conn.close()
    deleted = last_log("telefon", phone_id)
    check("удаление телефона записано",
          gone is None and deleted is not None and deleted["action"] == "delete",
          "" if deleted is not None else "нет строки")

    # ------------------------------------------------ ярлыки + последнее изменение
    _, page, _ = fetch(admin, "/AddJR.aspx")
    token = token_from(page)
    fetch(admin, "/AddJR.aspx",
          {"_csrf": token, "NameJarlik": MARKER + " Ярлык",
           "LnkNameJarlik": "audit-test.lnk"})
    conn = db()
    row = conn.execute('SELECT * FROM "Jarlik" WHERE "NameJarlik" = ?',
                       (MARKER + " Ярлык",)).fetchone()
    conn.close()
    check("тестовый ярлык создан", row is not None)
    if row is None:
        cleanup()
        return 1
    jarlik_id = row["IDJarlik"]

    status, page, _ = fetch(admin, f"/EditJR.aspx?id={jarlik_id}")
    check("форма редактирования ярлыка открывается", status == 200, f"status={status}")
    check("после создания пометка показывает автора",
          "last-change" in page and ADMIN_LOGIN in page)

    token = token_from(page)
    fetch(admin, f"/EditJR.aspx?id={jarlik_id}",
          {"_csrf": token, "action": "update",
           "NameJarlik": MARKER + " Ярлык (изм.)",
           "LnkNameJarlik": "audit-test-2.lnk"})

    status, page, _ = fetch(admin, f"/EditJR.aspx?id={jarlik_id}")
    check("после изменения видна пометка последнего изменения",
          "last-change" in page and "Последнее изменение" in page)
    check("в пометке указан автор изменения", ADMIN_LOGIN in page)
    check("в пометке указаны дата и время",
          re.search(r"\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}:\d{2}", page) is not None)
    check("пометка находится справа от заголовка «Редактирование»",
          re.search(r'class="page__head".*?class="page__title".*?class="last-change"',
                    page, re.S) is not None)

    _, page, _ = fetch(admin, f"/EditJR.aspx?id={jarlik_id}")
    token = token_from(page)
    fetch(admin, f"/EditJR.aspx?id={jarlik_id}",
          {"_csrf": token, "action": "delete"})
    conn = db()
    gone = conn.execute('SELECT 1 FROM "Jarlik" WHERE "IDJarlik" = ?',
                        (jarlik_id,)).fetchone()
    conn.close()
    deleted = last_log("Jarlik", jarlik_id)
    check("тестовый ярлык удалён и удаление записано",
          gone is None and deleted is not None and deleted["action"] == "delete")

    # ------------------------------------------------ IP-справочник: форма «Редактирование данных»
    _, page, _ = fetch(admin, "/Addipt4.aspx")
    token = token_from(page)
    ip_fields = {
        "Prolet": "10", "Uchastok": MARKER, "AgeregatName": MARKER,
        "Oc": "9999", "ConfigLogin": MARKER, "IPaddress": "0.0.0.0",
        "Shluz": "0.0.0.0", "MAC": MARKER, "KE": MARKER + "-KE",
        "Telephon": "", "Monitor": "", "Printer": "", "UPS": "",
        "Modem": "", "CISCO": "", "Opisanie": MARKER,
    }
    fetch(admin, "/Addipt4.aspx", {"_csrf": token, **ip_fields})
    conn = db()
    row = conn.execute('SELECT * FROM "IPaddress4" WHERE "KE" = ?',
                       (MARKER + "-KE",)).fetchone()
    conn.close()
    check("тестовая запись ТЭСК ТБД создана", row is not None)
    if row is None:
        cleanup()
        return 1
    ip_id = row["IDPC"]

    status, page, _ = fetch(admin, f"/Edit.aspx?id={ip_id}")
    check("форма «Редактирование данных» открывается", status == 200, f"status={status}")
    check("на форме IP видна пометка последнего изменения",
          "last-change" in page and ADMIN_LOGIN in page)
    check("пометка IP справа от заголовка «Редактирование данных»",
          re.search(r'class="page__head".*?Редактирование данных.*?class="last-change"',
                    page, re.S) is not None)

    token = token_from(page)
    fetch(admin, f"/Edit.aspx?id={ip_id}",
          {"_csrf": token, "action": "update",
           **{**ip_fields, "Opisanie": MARKER + " (изм.)"}})
    updated = last_log("IPaddress4", ip_id)
    check("изменение записи IP записано",
          updated is not None and updated["action"] == "update"
          and MARKER in (updated["details"] or ""),
          "" if updated is not None else "нет строки")

    _, page, _ = fetch(admin, f"/Edit.aspx?id={ip_id}")
    token = token_from(page)
    fetch(admin, f"/Edit.aspx?id={ip_id}", {"_csrf": token, "action": "delete"})
    conn = db()
    gone = conn.execute('SELECT 1 FROM "IPaddress4" WHERE "IDPC" = ?',
                        (ip_id,)).fetchone()
    conn.close()
    deleted = last_log("IPaddress4", ip_id)
    check("удаление записи IP записано",
          gone is None and deleted is not None and deleted["action"] == "delete")

    # ------------------------------------------------ фильтры журнала
    status, page, _ = fetch(admin, "/Logs.aspx")
    check("журнал содержит тестовые действия", MARKER in page)

    status, page, _ = fetch(admin, "/Logs.aspx?entity=telefon")
    check("фильтр по разделу «Телефоны»",
          status == 200 and "Телефоны" in page and MARKER in page)

    status, page, _ = fetch(admin, "/Logs.aspx?action=delete")
    check("фильтр по действию «Удаление»",
          status == 200 and "Удаление" in page and MARKER in page)

    status, page, _ = fetch(admin, "/Logs.aspx?username=" + ADMIN_LOGIN)
    check("фильтр по пользователю", status == 200 and MARKER in page)

    status, page, _ = fetch(admin, "/Logs.aspx?username=НетТакого")
    check("фильтр по несуществующему пользователю — пусто",
          status == 200 and "Записей нет" in page)

    status, page, _ = fetch(admin, "/Logs.aspx?date_from=2099-01-01")
    check("фильтр по будущей дате — пусто",
          status == 200 and "Записей нет" in page)

    # ------------------------------------------------ уборка
    cleanup()
    conn = db()
    leftovers = conn.execute(
        'SELECT COUNT(*) FROM "audit_log" WHERE "details" LIKE ?',
        ("%" + MARKER + "%",),
    ).fetchone()[0]
    conn.close()
    check("тестовые строки журнала удалены", leftovers == 0, f"осталось={leftovers}")

    print()
    print(f"ИТОГО: {passed}/{passed + failed} проверок пройдено")
    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
