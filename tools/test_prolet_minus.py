"""Проверка ввода отрицательного «Номера пролета» (-1) на формах ТЭСК ТБД и Все цеха.

Запуск (при работающем сервере):  python tools/test_prolet_minus.py

Внимание: тест работает только со своими записями. Маркер `PROLETMINUS`
не содержит символа `_`, чтобы его нельзя было спутать с шаблоном LIKE,
и реальные строки справочника не попадают под очистку.
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
MARKER = "PROLETMINUS"  # без «_»: символ «_» в LIKE — шаблон одного символа

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
    """Удалить только записи, созданные этим тестом."""
    conn = db()
    conn.execute('DELETE FROM "IPaddress4" WHERE "KE" LIKE ?', (MARKER + "%",))
    conn.execute('DELETE FROM "IPaddressAll" WHERE "KE" LIKE ?', (MARKER + "%",))
    conn.execute('DELETE FROM "audit_log" WHERE "details" LIKE ?',
                 ("%" + MARKER + "%",))
    conn.commit()
    conn.close()


IP4_FIELDS = {
    "Uchastok": MARKER, "AgeregatName": MARKER, "ConfigLogin": MARKER,
    "IPaddress": "0.0.0.0", "Shluz": "0.0.0.0", "MAC": MARKER,
    "Telephon": "", "Monitor": "", "Printer": "", "UPS": "",
    "Modem": "", "CISCO": "", "Opisanie": MARKER,
}


def find_row(table: str, ke: str):
    conn = db()
    row = conn.execute(f'SELECT * FROM "{table}" WHERE "KE" = ?', (ke,)).fetchone()
    conn.close()
    return row


def in_log(entity: str, record_id) -> bool:
    conn = db()
    row = conn.execute(
        'SELECT 1 FROM "audit_log" WHERE "entity" = ? AND "record_id" = ?',
        (entity, str(record_id)),
    ).fetchone()
    conn.close()
    return row is not None


def main() -> int:
    cleanup()
    admin = make_opener()
    if not login(admin, ADMIN_LOGIN, ADMIN_PASSWORD):
        print("FAIL вход admin")
        return 1

    # ---------------------------------------------- ТЭСК ТБД: пролет -1
    _, page, _ = fetch(admin, "/Addipt4.aspx")
    token = token_from(page)
    status, page, _ = fetch(admin, "/Addipt4.aspx",
                            {"_csrf": token, "Prolet": "-1", "Oc": "52",
                             "KE": MARKER + "-A", **IP4_FIELDS})
    check("ТЭСК ТБД: пролёт -1 сохраняется без ошибки",
          status in (301, 302), f"status={status}")

    row = find_row("IPaddress4", MARKER + "-A")
    check("ТЭСК ТБД: запись с пролётом -1 создана", row is not None)
    if row is not None:
        check("ТЭСК ТБД: в базе сохранён пролёт -1", row["Prolet"] == -1,
              f"Prolet={row['Prolet']}")
        check("ТЭСК ТБД: ось сохранена", row["Oc"] == 52, f"Oc={row['Oc']}")
        check("ТЭСК ТБД: запись попала в журнал", in_log("IPaddress4", row["IDPC"]))

    # ---------------------------------------------- ТЭСК ТБД: нечисло
    _, page, _ = fetch(admin, "/Addipt4.aspx")
    token = token_from(page)
    status, page, _ = fetch(admin, "/Addipt4.aspx",
                            {"_csrf": token, "Prolet": "abc", "Oc": "52",
                             "KE": MARKER + "-B", **IP4_FIELDS})
    check("ТЭСК ТБД: нечисловой пролёт отклонён",
          status == 200 and "Номером пролета должно быть число" in page,
          f"status={status}")
    check("ТЭСК ТБД: нечисловой пролёт не сохранён",
          find_row("IPaddress4", MARKER + "-B") is None)

    # ---------------------------------------------- ТЭСК ТБД: вне диапазона + force
    _, page, _ = fetch(admin, "/Addipt4.aspx")
    token = token_from(page)
    status, page, _ = fetch(admin, "/Addipt4.aspx",
                            {"_csrf": token, "Prolet": "20000", "Oc": "52",
                             "KE": MARKER + "-C", **IP4_FIELDS})
    check("ТЭСК ТБД: пролёт 20000 требует подтверждения",
          status == 200 and "Все равно сохранить" in page, f"status={status}")
    check("ТЭСК ТБД: без подтверждения пролёт 20000 не сохранён",
          find_row("IPaddress4", MARKER + "-C") is None)
    token = token_from(page)
    status, page, _ = fetch(admin, "/Addipt4.aspx",
                            {"_csrf": token, "force": "1", "Prolet": "20000",
                             "Oc": "52", "KE": MARKER + "-C", **IP4_FIELDS})
    check("ТЭСК ТБД: «Все равно сохранить» сохраняет пролёт 20000",
          status in (301, 302), f"status={status}")
    forced = find_row("IPaddress4", MARKER + "-C")
    check("ТЭСК ТБД: пролёт 20000 есть в базе",
          forced is not None and forced["Prolet"] == 20000)

    # ---------------------------------------------- Все цеха: пролет -1
    _, page, _ = fetch(admin, "/AddipALL.aspx")
    token = token_from(page)
    status, page, _ = fetch(admin, "/AddipALL.aspx",
                            {"_csrf": token, "ShopID": "1", "Prolet": "-1",
                             "Oc": "52", "KE": MARKER + "-D", **IP4_FIELDS})
    check("Все цеха: пролёт -1 сохраняется без ошибки", status == 200,
          f"status={status}")
    all_row = find_row("IPaddressAll", MARKER + "-D")
    check("Все цеха: запись с пролётом -1 создана",
          all_row is not None and all_row["Prolet"] == -1,
          "нет записи" if all_row is None else f"Prolet={all_row['Prolet']}")

    # ---------------------------------------------- редактирование своей записи с -1
    _, page, _ = fetch(admin, "/Addipt4.aspx")
    token = token_from(page)
    fetch(admin, "/Addipt4.aspx",
          {"_csrf": token, "Prolet": "-1", "Oc": "52",
           "KE": MARKER + "-F", **IP4_FIELDS})
    own = find_row("IPaddress4", MARKER + "-F")
    check("ТЭСК ТБД: запись для проверки правки создана", own is not None)
    if own is not None:
        status, page, _ = fetch(admin, f"/Edit.aspx?id={own['IDPC']}")
        check("ТЭСК ТБД: форма правки записи с пролётом -1 открывается",
              status == 200, f"status={status}")
        token = token_from(page)
        status, page, _ = fetch(admin, f"/Edit.aspx?id={own['IDPC']}",
                                {"_csrf": token, "Prolet": "-1", "Oc": "63",
                                 "KE": MARKER + "-F2", **IP4_FIELDS})
        check("ТЭСК ТБД: правка с пролётом -1 сохраняется",
              status in (301, 302), f"status={status}")
        edited = find_row("IPaddress4", MARKER + "-F2")
        check("ТЭСК ТБД: после правки пролёт остался -1",
              edited is not None and edited["Prolet"] == -1,
              "нет записи" if edited is None else f"Prolet={edited['Prolet']}")

    # ---------------------------------------------- проверка отсутствия следов
    cleanup()
    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "IPaddress4" WHERE "KE" LIKE ?',
                        (MARKER + "%",)).fetchone()[0]
    left += conn.execute('SELECT COUNT(*) FROM "IPaddressAll" WHERE "KE" LIKE ?',
                         (MARKER + "%",)).fetchone()[0]
    conn.close()
    check("тестовые записи удалены", left == 0, f"осталось={left}")

    print()
    print(f"ИТОГО: {passed}/{passed + failed} проверок пройдено")
    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
