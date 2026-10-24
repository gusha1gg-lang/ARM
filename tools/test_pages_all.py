"""Сквозной тест раздела «Все цеха» (Этап 4, партия 4).

Проверяет /IPaddrALL.aspx, /AddipALL.aspx, /EditALL.aspx:
права ролей, фильтры «Цех»/«Пролет», добавление/изменение/удаление, дубликаты,
валидацию, CSRF, сохранение без перезагрузки (как в оригинале).

Запуск (при работающем сервере):  python tools/test_pages_all.py
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

TEST_KE = "TEST-ALL-KE-001"
TEST_SHOP = 4  # КПЦ

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
    conn.execute('DELETE FROM "IPaddressAll" WHERE "KE" = ?', (TEST_KE,))
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


def payload(token: str, ke: str = TEST_KE, prolet: str = "1", oc: str = "1") -> dict:
    return {
        "_csrf": token,
        "ShopID": str(TEST_SHOP),
        "Prolet": prolet,
        "Uchastok": "ТЕСТ-УЧАСТОК-ALL",
        "AgeregatName": "T1",
        "Oc": oc,
        "ConfigLogin": "all-login",
        "IPaddress": "10.10.10.10",
        "Shluz": "10.10.10.1",
        "MAC": "00-11-22-33-44-55",
        "KE": ke,
        "Telephon": "11-11-11",
        "Monitor": "",
        "Printer": "",
        "UPS": "",
        "Modem": "",
        "CISCO": "10.10.0.1 (Gi0/1)",
        "Opisanie": "Все цеха тестовая запись",
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

    status, html, _ = fetch(viewer_op, "/IPaddrALL.aspx")
    check("viewer: /IPaddrALL.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок «IP адреса рабочих мест»", "IP адреса рабочих мест" in html)
    check("viewer: нет кнопки «Добавить»", ">Добавить<" not in html)
    check("viewer: нет ссылок редактирования", "/EditALL.aspx?id=" not in html)

    status, _, _ = fetch(viewer_op, "/AddipALL.aspx")
    check("viewer: /AddipALL.aspx → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/EditALL.aspx?id=1")
    check("viewer: /EditALL.aspx → 403", status == 403, f"status={status}")

    # ---------------- список
    conn = db()
    first_shop = conn.execute(
        'SELECT "ShopID", "ShopName" FROM "NameShop" ORDER BY "ShopName" LIMIT 1').fetchone()
    shop_total = conn.execute('SELECT COUNT(*) FROM "IPaddressAll" WHERE "ShopID" = ?',
                              (first_shop["ShopID"],)).fetchone()[0]
    shop_prolets = [r["Prolet"] for r in conn.execute(
        'SELECT DISTINCT "Prolet" FROM "IPaddressAll" WHERE "ShopID" = ? ORDER BY "Prolet"',
        (first_shop["ShopID"],))]
    shop3_prolets = [r["Prolet"] for r in conn.execute(
        'SELECT DISTINCT "Prolet" FROM "IPaddressAll" WHERE "ShopID" = 3 ORDER BY "Prolet"')]
    shop3_prolet2 = conn.execute(
        'SELECT COUNT(*) FROM "IPaddressAll" WHERE "ShopID" = 3 AND "Prolet" = 2').fetchone()[0]
    empty_shop = conn.execute(
        'SELECT "ShopID", "ShopName" FROM "NameShop" WHERE "ShopID" NOT IN '
        '(SELECT DISTINCT "ShopID" FROM "IPaddressAll") ORDER BY "ShopName" LIMIT 1').fetchone()
    conn.close()

    status, html, _ = fetch(admin_op, "/IPaddrALL.aspx")
    check("admin: /IPaddrALL.aspx → 200", status == 200, f"status={status}")
    check("admin: есть кнопка «Добавить»", ">Добавить<" in html)
    check("admin: есть ссылки редактирования", "/EditALL.aspx?id=" in html)
    check("по умолчанию выбран первый цех", "КПЦ" in html
          and f'<option value="{first_shop["ShopID"]}" selected>' in html)
    check(f'по умолчанию «все» пролёты, {shop_total} записей',
          f"Всего записей: {shop_total}" in html
          and f'<option value="-100" selected>' in html)
    check("список пролётов цеха = пролёты из БД + «все»",
          all(f'<option value="{p}"' in html for p in shop_prolets)
          and html.count('value="-100"') == 1)
    check("групповые строки «Пролет №:» и участка",
          "group-prolet" in html and "group-uchastok" in html)

    status, html, _ = fetch(admin_op, "/IPaddrALL.aspx?shop=3")
    check("смена цеха → свои пролёты (ЛПК)",
          all(f'<option value="{p}"' in html for p in shop3_prolets)
          and "Пролет" in html)

    status, html, _ = fetch(admin_op, "/IPaddrALL.aspx?shop=3&prolet=2")
    check(f"фильтр цех=3, пролет=2 → {shop3_prolet2} записей",
          f"Всего записей: {shop3_prolet2}" in html
          and f'<option value="2" selected>' in html)
    check("фильтр: только один заголовок пролёта",
          html.count('title="Номер пролета"') == 1)

    status, html, _ = fetch(admin_op, "/IPaddrALL.aspx?shop=zzz&prolet=zzz")
    check("некорректные параметры → значения по умолчанию",
          f"Всего записей: {shop_total}" in html
          and f'<option value="-100" selected>' in html)

    if empty_shop is not None:
        status, html, _ = fetch(admin_op,
                                f"/IPaddrALL.aspx?shop={empty_shop['ShopID']}")
        check("цех без записей → «Всего записей: 0», только пункт «все»",
              status == 200 and "Всего записей: 0" in html
              and "group-prolet" not in html)

    # ---------------- editor: форма добавления
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    status, html, _ = fetch(editor_op, "/AddipALL.aspx")
    check("editor: /AddipALL.aspx → 200",
          status == 200 and "Добавление данных" in html, f"status={status}")
    check("форма: список цехов", '<select class="select" name="ShopID">' in html)
    token = token_from(html)

    no_csrf = payload(token)
    no_csrf.pop("_csrf")
    status, _, _ = fetch(editor_op, "/AddipALL.aspx", no_csrf)
    check("POST без CSRF → 400", status == 400, f"status={status}")

    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token, prolet=""))
    check("Пустой пролет → «Требуется номер пролета»",
          status == 200 and "Требуется номер пролета" in html)
    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token, prolet="abc"))
    check("Нечисловой пролет → «Номером пролета должно быть число»",
          status == 200 and "Номером пролета должно быть число" in html)
    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token, oc=""))
    check("Пустая ось → «Недопустимый формат данных»",
          status == 200 and "Недопустимый формат данных" in html)
    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token, oc="abc"))
    check("Нечисловая ось → «Введите число, чтобы указать ось»",
          status == 200 and "Введите число, чтобы указать ось" in html)

    # Добавление — без перезагрузки, форма очищается (как в оригинале)
    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token))
    check("Добавление → остаёмся на форме (200)", status == 200, f"status={status}")
    check("Добавление → сообщение и очищенная форма",
          "Запись добавлена." in html and 'value="10.10.10.10"' not in html)

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddressAll" WHERE "KE" = ?', (TEST_KE,)).fetchone()
    check("Запись сохранена в БД", row is not None)
    check("Поля сохранены верно",
          row is not None and row["ShopID"] == TEST_SHOP and row["Prolet"] == 1
          and row["Oc"] == 1 and row["Uchastok"] == "ТЕСТ-УЧАСТОК-ALL"
          and row["Opisanie"] == "Все цеха тестовая запись")
    row_id = row["IDPC"] if row else None
    conn.close()

    status, html, _ = fetch(editor_op, f"/IPaddrALL.aspx?shop={TEST_SHOP}")
    check("Новая запись видна в списке цеха", TEST_KE in html)

    # Редактирование
    status, html, _ = fetch(editor_op, f"/EditALL.aspx?id={row_id}")
    check("Форма редактирования заполнена",
          status == 200 and "Редактирование данных" in html and TEST_KE in html)
    check("В форме выбран цех записи",
          f'<option value="{TEST_SHOP}" selected>' in html)
    token = token_from(html)

    upd = payload(token)
    upd["IPaddress"] = "10.10.20.30"
    upd["AgeregatName"] = "T2"
    upd["Opisanie"] = "изменённое описание ВСЕ"
    status, _, _ = fetch(editor_op, f"/EditALL.aspx?id={row_id}", upd)
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPaddressAll" WHERE "IDPC" = ?', (row_id,)).fetchone()
    check("Изменения записаны",
          row["IPaddress"] == "10.10.20.30"
          and row["AgeregatName"] == "T2"
          and row["Opisanie"] == "изменённое описание ВСЕ")
    conn.close()

    # Дубликат КЕ при добавлении
    status, html, _ = fetch(editor_op, "/AddipALL.aspx")
    token = token_from(html)
    status, html, _ = fetch(editor_op, "/AddipALL.aspx", payload(token))
    check("Дубликат КЕ (добавление) → предупреждение",
          status == 200 and "ты уверен что желаешь сохранить?" in html)
    check("Дубликат КЕ → кнопка «Все равно сохранить»", "Все равно сохранить" in html)

    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddressAll" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("Без подтверждения дубликат не добавлен", count == 1, f"count={count}")

    force = payload(token)
    force["force"] = "1"
    status, _, _ = fetch(editor_op, "/AddipALL.aspx", force)
    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPaddressAll" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("«Все равно сохранить» добавляет запись", count == 2, f"count={count}")

    # Дубликат КЕ при редактировании
    _, html, _ = fetch(editor_op, f"/EditALL.aspx?id={row_id}")
    token = token_from(html)
    status, html, _ = fetch(editor_op, f"/EditALL.aspx?id={row_id}",
                            {**payload(token), "AgeregatName": "T3"})
    check("Дубликат КЕ (редактирование) → предупреждение",
          status == 200 and "ты уверен что желаешь сохранить?" in html)
    conn = db()
    agg = conn.execute('SELECT "AgeregatName" FROM "IPaddressAll" WHERE "IDPC" = ?',
                       (row_id,)).fetchone()[0]
    conn.close()
    check("Без подтверждения изменения не сохранены", agg == "T2", f"ageregat={agg}")

    # Удаление
    conn = db()
    ids = [r["IDPC"] for r in conn.execute(
        'SELECT "IDPC" FROM "IPaddressAll" WHERE "KE" = ?', (TEST_KE,))]
    conn.close()

    for rid in ids:
        _, html, _ = fetch(editor_op, f"/EditALL.aspx?id={rid}")
        token = token_from(html)
        status, _, _ = fetch(editor_op, f"/EditALL.aspx?id={rid}",
                             {"_csrf": token, "action": "delete"})
        check(f"Удаление записи №{rid} → редирект", status in (301, 302),
              f"status={status}")

    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "IPaddressAll" WHERE "KE" = ?',
                        (TEST_KE,)).fetchone()[0]
    total = conn.execute('SELECT COUNT(*) FROM "IPaddressAll"').fetchone()[0]
    conn.close()
    check("Тестовые записи удалены", left == 0, f"left={left}")
    check("Количество строк IPaddressAll = 542", total == 542, f"total={total}")

    status, _, _ = fetch(editor_op, "/EditALL.aspx?id=999999")
    check("Несуществующая запись → 404", status == 404, f"status={status}")

    status, _, _ = fetch(viewer_op, "/AddipALL.aspx", payload("x"))
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
