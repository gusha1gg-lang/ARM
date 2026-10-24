"""Сквозной тест раздела «АБК» (Этап 4, партия 3).

Проверяет /IPaddrUch.aspx, /Addipuch.aspx, /EditUch.aspx:
права ролей, фильтр по участку, добавление/изменение/удаление, дубликаты,
валидацию «Этажа», CSRF.

Запуск (при работающем сервере):  python tools/test_pages_uch.py
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

TEST_KE = "TEST-ABK-KE-001"
TEST_UCHASTOK = 1  # IDUchastok = 1 совпадает с IDPC тестовой записи — удобно для проверок

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
    conn.execute('DELETE FROM "IPAddressUch" WHERE "KE" = ?', (TEST_KE,))
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


def payload(token: str, ke: str = TEST_KE, level: str = "2",
            uchastok: str = str(TEST_UCHASTOK)) -> dict:
    return {
        "_csrf": token,
        "IDUchastok": uchastok,
        "Level": level,
        "Kabinet": "999",
        "ConfigLogin": "abk-test",
        "IPaddress": "10.9.9.9",
        "CISCO": "10.9.0.1 (Gi0/1)",
        "MAC": "AA-BB-CC-DD-EE-FF",
        "KE": ke,
        "Telephon": "99-99-99",
        "Monitor": "",
        "Printer": "",
        "UPS": "",
        "Modem": "",
        "Opisanie": "АБК тестовая запись",
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

    status, html, _ = fetch(viewer_op, "/IPaddrUch.aspx")
    check("viewer: /IPaddrUch.aspx → 200", status == 200, f"status={status}")
    check("viewer: заголовок «Информация об АРМ на внешних участках»",
          "Информация об АРМ на внешних участках" in html)
    check("viewer: нет кнопки «Добавить»", ">Добавить<" not in html)
    check("viewer: нет ссылок редактирования", "/EditUch.aspx?id=" not in html)

    status, _, _ = fetch(viewer_op, "/Addipuch.aspx")
    check("viewer: /Addipuch.aspx → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, "/EditUch.aspx?id=1")
    check("viewer: /EditUch.aspx → 403", status == 403, f"status={status}")

    # ---------------- список: участок по умолчанию и фильтр
    status, html, _ = fetch(admin_op, "/IPaddrUch.aspx")
    check("admin: /IPaddrUch.aspx → 200", status == 200, f"status={status}")
    check("admin: есть кнопка «Добавить»", ">Добавить<" in html)
    check("admin: есть ссылки редактирования", "/EditUch.aspx?id=" in html)

    conn = db()
    first = conn.execute(
        'SELECT "IDUchastok", "Nameuchastka" FROM "NameUchastok" '
        'ORDER BY "Nameuchastka" LIMIT 1').fetchone()
    first_count = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "IDUchastok" = ?',
                               (first["IDUchastok"],)).fetchone()[0]
    c3_name = conn.execute('SELECT "Nameuchastka" FROM "NameUchastok" WHERE "IDUchastok" = 3'
                           ).fetchone()[0]
    c3_count = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "IDUchastok" = 3'
                            ).fetchone()[0]
    conn.close()

    check("по умолчанию выбран первый участок (АБК 5)",
          f'<option value="{first["IDUchastok"]}" selected>' in html
          and first["Nameuchastka"] in html)
    check(f'по умолчанию «Всего записей: {first_count}»',
          f"Всего записей: {first_count}" in html)
    check("заголовок участка отрисован",
          f"Участок: {first['Nameuchastka']}" in html and "group-uchastok-abk" in html)

    status, html, _ = fetch(admin_op, "/IPaddrUch.aspx?uchastok=3")
    check("фильтр ?uchastok=3 → заголовок ЦЗЛ", f"Участок: {c3_name}" in html)
    check(f"фильтр ?uchastok=3 → {c3_count} записей",
          f"Всего записей: {c3_count}" in html)

    status, html, _ = fetch(admin_op, "/IPaddrUch.aspx?uchastok=zzz")
    check("некорректный участок → первый по умолчанию",
          f"Участок: {first['Nameuchastka']}" in html)

    empty = None
    conn = db()
    for row in conn.execute('SELECT "IDUchastok", "Nameuchastka" FROM "NameUchastok" '
                            'ORDER BY "Nameuchastka"'):
        cnt = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "IDUchastok" = ?',
                           (row["IDUchastok"],)).fetchone()[0]
        if cnt == 0:
            empty = row
            break
    conn.close()
    if empty is not None:
        status, html, _ = fetch(admin_op, f"/IPaddrUch.aspx?uchastok={empty['IDUchastok']}")
        check("пустой участок → нет строки-заголовка (как в оригинале)",
              status == 200 and "group-uchastok-abk" not in html
              and "Всего записей: 0" in html)

    # ---------------- editor: форма добавления
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    status, html, _ = fetch(editor_op, "/Addipuch.aspx")
    check("editor: /Addipuch.aspx → 200",
          status == 200 and "Добавлени данных" in html, f"status={status}")
    check("форма: список участков, выбран первый",
          '<select class="select" name="IDUchastok">' in html)
    token = token_from(html)

    # CSRF
    no_csrf = payload(token)
    no_csrf.pop("_csrf")
    status, _, _ = fetch(editor_op, "/Addipuch.aspx", no_csrf)
    check("POST без CSRF → 400", status == 400, f"status={status}")

    # Валидация «Этаж»
    status, html, _ = fetch(editor_op, "/Addipuch.aspx", payload(token, level=""))
    check("Пустой этаж → «Требуется этаж»",
          status == 200 and "Требуется этаж" in html)
    status, html, _ = fetch(editor_op, "/Addipuch.aspx", payload(token, level="abc"))
    check("Нечисловой этаж → «Этаж должен быть числом»",
          status == 200 and "Этаж должен быть числом" in html)

    # Некорректный участок
    status, html, _ = fetch(editor_op, "/Addipuch.aspx", payload(token, uchastok="999"))
    check("Несуществующий участок → «Выберите участок из списка.»",
          status == 200 and "Выберите участок из списка." in html)

    # Добавление
    status, _, _ = fetch(editor_op, "/Addipuch.aspx", payload(token))
    check("Добавление записи → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPAddressUch" WHERE "KE" = ?', (TEST_KE,)).fetchone()
    check("Запись сохранена в БД", row is not None)
    check("Поля сохранены верно",
          row is not None and row["IDUchastok"] == TEST_UCHASTOK and row["Level"] == 2
          and row["Kabinet"] == "999" and row["Opisanie"] == "АБК тестовая запись")
    row_id = row["IDPC"] if row else None
    conn.close()

    status, html, _ = fetch(editor_op, f"/IPaddrUch.aspx?uchastok={TEST_UCHASTOK}")
    check("Новая запись видна в списке участка", TEST_KE in html)

    # Редактирование
    status, html, _ = fetch(editor_op, f"/EditUch.aspx?id={row_id}")
    check("Форма редактирования заполнена",
          status == 200 and "Редактирование данных" in html and TEST_KE in html)
    check("В форме выбран участок записи",
          f'<option value="{TEST_UCHASTOK}" selected>' in html)
    token = token_from(html)

    upd = payload(token)
    upd["IPaddress"] = "10.9.8.7"
    upd["Level"] = "5"
    upd["Opisanie"] = "изменённое описание АБК"
    status, _, _ = fetch(editor_op, f"/EditUch.aspx?id={row_id}", upd)
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "IPAddressUch" WHERE "IDPC" = ?', (row_id,)).fetchone()
    check("Изменения записаны",
          row["IPaddress"] == "10.9.8.7" and row["Level"] == 5
          and row["Opisanie"] == "изменённое описание АБК")
    conn.close()

    # Дубликат КЕ при добавлении — текст оригинала
    status, html, _ = fetch(editor_op, "/Addipuch.aspx")
    token = token_from(html)
    status, html, _ = fetch(editor_op, "/Addipuch.aspx", payload(token))
    check("Дубликат КЕ (добавление) → предупреждение", status == 200 and "уже существует" in html)
    check("Дубликат КЕ (добавление) → текст оригинала",
          "КЕ с таким номером уже существует, ты уверен что желаешь сохранить?" in html)
    check("Дубликат КЕ → кнопка «Все равно сохранить»", "Все равно сохранить" in html)

    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("Без подтверждения дубликат не добавлен", count == 1, f"count={count}")

    force = payload(token)
    force["force"] = "1"
    status, _, _ = fetch(editor_op, "/Addipuch.aspx", force)
    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "KE" = ?',
                         (TEST_KE,)).fetchone()[0]
    conn.close()
    check("«Все равно сохранить» добавляет запись", count == 2, f"count={count}")

    # Дубликат КЕ при редактировании — текст оригинала («Братюня…»)
    _, html, _ = fetch(editor_op, f"/EditUch.aspx?id={row_id}")
    token = token_from(html)
    status, html, _ = fetch(editor_op, f"/EditUch.aspx?id={row_id}",
                            {**payload(token), "Kabinet": "888"})
    check("Дубликат КЕ (редактирование) → текст оригинала",
          status == 200 and "Братюня, КЕ с таким номером уже существует, "
                            "ты уверен что желаешь добавить?" in html)
    conn = db()
    kab = conn.execute('SELECT "Kabinet" FROM "IPAddressUch" WHERE "IDPC" = ?',
                       (row_id,)).fetchone()[0]
    conn.close()
    check("Без подтверждения изменения не сохранены", kab == "999", f"kabinet={kab}")

    # Удаление
    conn = db()
    ids = [r["IDPC"] for r in conn.execute(
        'SELECT "IDPC" FROM "IPAddressUch" WHERE "KE" = ?', (TEST_KE,))]
    conn.close()

    for rid in ids:
        _, html, _ = fetch(editor_op, f"/EditUch.aspx?id={rid}")
        token = token_from(html)
        status, _, _ = fetch(editor_op, f"/EditUch.aspx?id={rid}",
                             {"_csrf": token, "action": "delete"})
        check(f"Удаление записи №{rid} → редирект", status in (301, 302),
              f"status={status}")

    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "IPAddressUch" WHERE "KE" = ?',
                        (TEST_KE,)).fetchone()[0]
    total = conn.execute('SELECT COUNT(*) FROM "IPAddressUch"').fetchone()[0]
    conn.close()
    check("Тестовые записи удалены", left == 0, f"left={left}")
    check("Количество строк IPAddressUch = 1733", total == 1733, f"total={total}")

    status, _, _ = fetch(editor_op, "/EditUch.aspx?id=999999")
    check("Несуществующая запись → 404", status == 404, f"status={status}")

    status, _, _ = fetch(viewer_op, "/Addipuch.aspx", payload("x"))
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
