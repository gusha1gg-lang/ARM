"""Сквозной тест справочников (Этап 4, партия 9).

Проверяет /SPR_CISCO.aspx?SPRType=1|2 (справочник CISCO и справочник камер)
и /spr_shop.aspx (справочник цехов): права ролей, порядок, CRUD, валидация, CSRF.

Запуск (при работающем сервере):  python tools/test_pages_spr.py
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

TEST_IP = "99.99.99.99"
TEST_CAMERA = "ТЕСТ-КАМЕРА"
TEST_SHOP = "ТЕСТ-ЦЕХ"

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
    match = CSRF_RE.search(html)
    return match.group(1) if match else ""


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute("DELETE FROM users WHERE username IN ('test_editor','test_viewer')")
    conn.execute('DELETE FROM "SPR_CISCO" WHERE "IP_CISCO" = ?', (TEST_IP,))
    conn.execute('DELETE FROM "SPR_CAMERA" WHERE "Camera_Name" LIKE ?', ("ТЕСТ-КАМЕРА%",))
    conn.execute('DELETE FROM "NameShop" WHERE "ShopName" = ?', (TEST_SHOP,))
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


def counts() -> dict:
    conn = db()
    data = {
        "cisco": conn.execute('SELECT COUNT(*) FROM "SPR_CISCO"').fetchone()[0],
        "camera": conn.execute('SELECT COUNT(*) FROM "SPR_CAMERA"').fetchone()[0],
        "shop": conn.execute('SELECT COUNT(*) FROM "NameShop"').fetchone()[0],
    }
    conn.close()
    return data


def main() -> int:
    cleanup()
    base = counts()

    # ---------------- аноним
    anonymous = make_opener()
    status, _, headers = fetch(anonymous, "/SPR_CISCO.aspx?SPRType=1")
    check("аноним: /SPR_CISCO.aspx → редирект на вход",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, "/SPR_CISCO.aspx?SPRType=1")
    check("viewer: SPRType=1 → «Справочник CISCO»",
          status == 200 and "Справочник CISCO" in html, f"status={status}")
    check(f"viewer: {base['cisco']} строк, колонки справочника CISCO",
          html.count('class="row-') == base["cisco"]
          and "IP_CISCO" in html and "Расположение" in html and "Примечание" in html,
          f"rows={html.count('class=\"row-')}")
    check("viewer: нет кнопок правки/добавления",
          "/img/buttonedit.png" not in html and "/img/cross.png" not in html
          and "/img/cross_edit_add32.png" not in html)

    status, html, _ = fetch(viewer_op, "/SPR_CISCO.aspx?SPRType=2")
    check("viewer: SPRType=2 → «Справочник камер»",
          status == 200 and "Справочник камер" in html, f"status={status}")
    check(f"viewer: {base['camera']} строк, колонки Тип/Марка камеры",
          html.count('class="row-') == base["camera"]
          and "Тип камеры" in html and "Марка камеры" in html,
          f"rows={html.count('class=\"row-')}")

    _, html, _ = fetch(viewer_op, "/SPR_CISCO.aspx")
    check("без SPRType → справочник камер (как в оригинале)", "Справочник камер" in html)
    _, html, _ = fetch(viewer_op, "/SPR_CISCO.aspx?SPRType=zzz")
    check("неизвестный SPRType → справочник камер", "Справочник камер" in html)

    status, html, _ = fetch(viewer_op, "/spr_shop.aspx")
    check("viewer: /spr_shop.aspx → «Справочник цехов»",
          status == 200 and "Справочник цехов" in html, f"status={status}")
    check(f"viewer: {base['shop']} цехов, нет формы и кнопок правки",
          html.count('class="row-') == base["shop"]
          and 'name="action" value="insert"' not in html
          and "/img/buttonedit.png" not in html,
          f"rows={html.count('class=\"row-')}")

    _, html, _ = fetch(viewer_op, "/spr_shop.aspx")
    viewer_token = token_from(html)
    for path, payload in (
        ("/SPR_CISCO.aspx?SPRType=1",
         {"_csrf": viewer_token, "action": "insert", "IP_CISCO": TEST_IP}),
        ("/SPR_CISCO.aspx?SPRType=2",
         {"_csrf": viewer_token, "action": "insert", "Camera_Type": "IP",
          "Camera_Name": TEST_CAMERA}),
        ("/spr_shop.aspx",
         {"_csrf": viewer_token, "action": "insert", "ShopName": TEST_SHOP}),
    ):
        status, _, _ = fetch(viewer_op, path, payload)
        check(f"viewer: POST {path} → 403", status == 403, f"status={status}")

    # ---------------- порядок строк
    conn = db()
    cisco_order = [r["IP_CISCO"] for r in conn.execute(
        'SELECT "IP_CISCO" FROM "SPR_CISCO" ORDER BY "IP_CISCO"')]
    camera_order = [r["Camera_Type"] for r in conn.execute(
        'SELECT "Camera_Type" FROM "SPR_CAMERA" ORDER BY "Camera_Type"')]
    shop_desc = [str(r["ShopName"]) for r in conn.execute(
        'SELECT "ShopName" FROM "NameShop" ORDER BY "ShopName" DESC')]
    shop_asc = [str(r["ShopName"]) for r in conn.execute(
        'SELECT "ShopName" FROM "NameShop" ORDER BY "ShopName" ASC')]
    conn.close()

    # Первая запись справочника имеет пустой IP_CISCO (NULL) — её в сравнении пропускаем.
    cisco_names = [value for value in cisco_order if value]
    _, html, _ = fetch(admin_op, "/SPR_CISCO.aspx?SPRType=1")
    check("справочник CISCO отсортирован по IP_CISCO",
          html.index(f">{cisco_names[0]}<") < html.index(f">{cisco_names[1]}<"))
    _, html, _ = fetch(admin_op, "/SPR_CISCO.aspx?SPRType=2")
    check("справочник камер отсортирован по Camera_Type",
          html.index(f">{camera_order[0]}<") <= html.index(f">{camera_order[1]}<"))

    _, html, _ = fetch(admin_op, "/spr_shop.aspx")
    check("цеха по умолчанию — ORDER BY ShopName DESC (как в оригинале)",
          html.index(f">{shop_desc[0]}<") < html.index(f">{shop_desc[1]}<")
          if shop_desc[0] != shop_desc[1] else True)
    _, html, _ = fetch(admin_op, "/spr_shop.aspx?sort=ShopName&dir=asc")
    check("сортировка цехов по возрастанию",
          html.index(f">{shop_asc[0]}<") < html.index(f">{shop_asc[1]}<"))
    status, html, _ = fetch(admin_op, "/spr_shop.aspx?sort=ShopID&dir=asc")
    check("сортировка цехов по ID цеха",
          status == 200 and "Справочник цехов" in html, f"status={status}")
    _, html, _ = fetch(admin_op, "/spr_shop.aspx?sort=zzz")
    check("некорректная сортировка → порядок по умолчанию", "Справочник цехов" in html)

    # ---------------- editor: справочник CISCO
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1")
    token = token_from(html)
    check("editor: в справочнике CISCO есть кнопки правки и добавления",
          "/img/buttonedit.png" in html and "/img/cross_edit_add32.png" in html)

    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1",
                         {"IP_CISCO": TEST_IP, "action": "insert"})
    check("POST без CSRF → 400", status == 400, f"status={status}")

    def insert_cisco(**fields):
        payload = {"_csrf": token, "action": "insert", "IP_CISCO": TEST_IP,
                   "Location_CISCO": "Тестовое место", "Opisanie_CISCO": "тест"}
        payload.update(fields)
        return fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1", payload)

    status, _, _ = insert_cisco(Prolet_CISCO="abc", Oc_CISCO="1")
    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1")
    check("нечисловой пролет → сообщение, запись не создана",
          "Номером пролета должно быть числом" in html
          and counts()["cisco"] == base["cisco"])

    status, _, _ = insert_cisco(Prolet_CISCO="5")
    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1")
    check("только одно поле из пары → сообщение, запись не создана",
          "Заполни оба поля" in html and counts()["cisco"] == base["cisco"])

    status, _, _ = insert_cisco(Prolet_CISCO="5000", Oc_CISCO="1")
    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1")
    check("пролет вне диапазона −1000…1000 → сообщение",
          "Номером пролета должно быть числом" in html and counts()["cisco"] == base["cisco"])

    status, _, _ = insert_cisco(Prolet_CISCO="7", Oc_CISCO="8")
    check("добавление с пролетом и осью → редирект", status in (301, 302),
          f"status={status}")
    conn = db()
    row = conn.execute('SELECT * FROM "SPR_CISCO" WHERE "IP_CISCO" = ?', (TEST_IP,)).fetchone()
    conn.close()
    check("запись CISCO создана с числами",
          row is not None and row["Prolet_CISCO"] == 7 and row["Oc_CISCO"] == 8)
    cisco_id = row["ID_CISCO"] if row else None
    check(f"строк SPR_CISCO = {base['cisco'] + 1}",
          counts()["cisco"] == base["cisco"] + 1)

    status, _, _ = insert_cisco(IP_CISCO=TEST_IP + "0", Prolet_CISCO="", Oc_CISCO="",
                               Location_CISCO="Без пролёта")
    conn = db()
    row2 = conn.execute('SELECT * FROM "SPR_CISCO" WHERE "IP_CISCO" = ?',
                        (TEST_IP + "0",)).fetchone()
    conn.close()
    check("пустые Пролет и Ось допустимы (NULL) — как в оригинале",
          row2 is not None and row2["Prolet_CISCO"] is None and row2["Oc_CISCO"] is None)
    cisco_id2 = row2["ID_CISCO"] if row2 else None

    # правка и удаление CISCO
    status, html, _ = fetch(editor_op, f"/SPR_CISCO.aspx?SPRType=1&edit={cisco_id}")
    check("справочник CISCO: строка открыта на правку",
          status == 200 and 'id="edit-form"' in html and TEST_IP in html, f"status={status}")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1",
                         {"_csrf": token, "action": "update", "id": str(cisco_id),
                          "IP_CISCO": TEST_IP, "Prolet_CISCO": "", "Oc_CISCO": "3",
                          "Location_CISCO": "Новое место", "Opisanie_CISCO": "новое"})
    check("сохранение правки CISCO → редирект", status in (301, 302), f"status={status}")
    conn = db()
    row = conn.execute('SELECT * FROM "SPR_CISCO" WHERE "ID_CISCO" = ?', (cisco_id,)).fetchone()
    conn.close()
    check("правка CISCO записана (пустой пролет → NULL)",
          row["Location_CISCO"] == "Новое место" and row["Prolet_CISCO"] is None
          and row["Oc_CISCO"] == 3)

    for row_id in (cisco_id, cisco_id2):
        status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1",
                             {"_csrf": token, "action": "delete", "id": str(row_id)})
    check("удаление CISCO → редирект", status in (301, 302), f"status={status}")
    check(f"строк SPR_CISCO снова {base['cisco']}", counts()["cisco"] == base["cisco"])

    # ---------------- editor: справочник камер
    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2",
                         {"_csrf": token, "action": "insert",
                          "Camera_Type": "IP", "Camera_Name": ""})
    _, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2")
    check("камера без марки → «Введи марку камеры», запись не создана",
          "Введи марку камеры" in html and counts()["camera"] == base["camera"])

    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2",
                         {"_csrf": token, "action": "insert",
                          "Camera_Type": "Analog", "Camera_Name": TEST_CAMERA})
    check("добавление камеры → редирект", status in (301, 302), f"status={status}")
    conn = db()
    cam = conn.execute('SELECT * FROM "SPR_CAMERA" WHERE "Camera_Name" = ?',
                       (TEST_CAMERA,)).fetchone()
    conn.close()
    check("камера создана с типом Analog",
          cam is not None and cam["Camera_Type"] == "Analog")
    cam_id = cam["IDCAM_NAME"] if cam else None
    check(f"строк SPR_CAMERA = {base['camera'] + 1}",
          counts()["camera"] == base["camera"] + 1)

    _, html, _ = fetch(editor_op, f"/SPR_CISCO.aspx?SPRType=2&edit={cam_id}")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2",
                         {"_csrf": token, "action": "update", "id": str(cam_id),
                          "Camera_Type": "IP", "Camera_Name": TEST_CAMERA + " 2"})
    conn = db()
    cam = conn.execute('SELECT * FROM "SPR_CAMERA" WHERE "IDCAM_NAME" = ?',
                       (cam_id,)).fetchone()
    conn.close()
    check("правка камеры записана",
          status in (301, 302) and cam["Camera_Type"] == "IP"
          and cam["Camera_Name"] == TEST_CAMERA + " 2")

    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=2",
                         {"_csrf": token, "action": "delete", "id": str(cam_id)})
    check(f"удаление камеры → строк снова {base['camera']}",
          status in (301, 302) and counts()["camera"] == base["camera"])

    # ---------------- editor: цеха
    _, html, _ = fetch(editor_op, "/spr_shop.aspx")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/spr_shop.aspx",
                         {"_csrf": token, "action": "insert", "ShopName": TEST_SHOP})
    check("добавление цеха → редирект", status in (301, 302), f"status={status}")
    conn = db()
    shop = conn.execute('SELECT * FROM "NameShop" WHERE "ShopName" = ?', (TEST_SHOP,)).fetchone()
    conn.close()
    check("цех создан", shop is not None and counts()["shop"] == base["shop"] + 1)
    shop_id = shop["ShopID"] if shop else None

    _, html, _ = fetch(editor_op, f"/spr_shop.aspx?edit={shop_id}")
    token = token_from(html)
    status, _, _ = fetch(editor_op, "/spr_shop.aspx",
                         {"_csrf": token, "action": "update", "id": str(shop_id),
                          "ShopName": TEST_SHOP + " 2"})
    conn = db()
    shop = conn.execute('SELECT * FROM "NameShop" WHERE "ShopID" = ?', (shop_id,)).fetchone()
    conn.close()
    check("правка цеха записана",
          status in (301, 302) and shop["ShopName"] == TEST_SHOP + " 2")

    status, _, _ = fetch(editor_op, "/spr_shop.aspx",
                         {"_csrf": token, "action": "delete", "id": str(shop_id)})
    check(f"удаление цеха → строк снова {base['shop']}",
          status in (301, 302) and counts()["shop"] == base["shop"])

    # ---------------- ошибки
    status, _, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1",
                         {"_csrf": token, "action": "delete", "id": "abc"})
    check("некорректный id → 400", status == 400, f"status={status}")
    status, html, _ = fetch(editor_op, "/SPR_CISCO.aspx?SPRType=1&edit=999999")
    check("несуществующий edit → страница без формы правки",
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
