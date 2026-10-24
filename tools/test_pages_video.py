"""Сквозной тест раздела «Видеонаблюдение» (Этап 4, партия 5).

Проверяет /VideoIP.aspx?VideoType=IP|Analog:
права ролей, фильтры «Цех»/«Пролет», разные наборы колонок, добавление,
изменение, удаление, загрузку изображения, валидацию оси, CSRF.

Запуск (при работающем сервере):  python tools/test_pages_video.py
"""
from __future__ import annotations

import http.cookiejar
import json
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
UPLOAD_DIR = os.path.join(ROOT, "uploads")

TEST_MARK = "ТЕСТ-ВИДЕО"
TEST_UPLOAD = "test-video-upload.png"
PNG_BYTES = bytes.fromhex(
    "89504e470d0a1a0a0000000d49484452000000010000000108060000001f15c4"
    "890000000a49444154789c6360000002000154a24f5f0000000049454e44ae42"
    "6082"
)

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


def post_multipart(opener, path, fields: dict, files: dict):
    boundary = "----armomktestboundary"
    chunks: list[bytes] = []
    for name, value in fields.items():
        chunks.append(
            f'--{boundary}\r\nContent-Disposition: form-data; name="{name}"\r\n\r\n'
            f"{value}\r\n".encode("utf-8")
        )
    for name, (filename, content) in files.items():
        chunks.append(
            f'--{boundary}\r\nContent-Disposition: form-data; name="{name}"; '
            f'filename="{filename}"\r\nContent-Type: application/octet-stream\r\n\r\n'.encode("utf-8")
        )
        chunks.append(content)
        chunks.append(b"\r\n")
    chunks.append(f"--{boundary}--\r\n".encode("utf-8"))
    body = b"".join(chunks)
    req = urllib.request.Request(BASE + path, data=body, method="POST")
    req.add_header("Content-Type", f"multipart/form-data; boundary={boundary}")
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace")


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
    conn.execute('DELETE FROM "Video_Camera_all" WHERE "Uchastok" = ?', (TEST_MARK,))
    conn.commit()
    conn.close()
    for name in (TEST_UPLOAD,):
        path = os.path.join(UPLOAD_DIR, name)
        if os.path.exists(path):
            os.remove(path)


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


def insert_payload(token: str, **overrides) -> dict:
    data = {
        "_csrf": token,
        "action": "insert",
        "ShopID": "11",
        "Prolet": "0",
        "Uchastok": TEST_MARK,
        "Oc": "77",
        "IPaddress": "10.99.99.99",
        "Camera_number": "Тестовая камера",
        "IDCAM_NAME": "1",
        "IP_Server_PC": "10.99.99.1",
        "IP_CAMERA_STREAM": "http://example.local/stream",
        "Login_password": "root/test",
        "ID_CISCO": "1",
        "Port_CISCO": "Gi0/1",
        "Video_out_lacation_PC": "Тестовый регистратор",
        "Monitor": "TEST-MON",
        "Opisanie": "тестовое примечание",
        "upload_img": f"uploads/{TEST_UPLOAD}",
    }
    data.update(overrides)
    return data


def page_url(video_type: str, shop: str = "11", prolet: str = "0") -> str:
    return (f"/VideoIP.aspx?VideoType={video_type}&shop={shop}&prolet={prolet}")


def main() -> int:
    cleanup()

    admin_op = make_opener()
    check("Вход admin", login(admin_op, "admin", "11111111"))
    create_user(admin_op, "test_editor", "editor123", "editor")
    create_user(admin_op, "test_viewer", "viewer123", "viewer")

    # ---------------- viewer
    viewer_op = make_opener()
    check("Вход test_viewer", login(viewer_op, "test_viewer", "viewer123"))

    status, html, _ = fetch(viewer_op, page_url("IP"))
    check("viewer: IP → 200", status == 200, f"status={status}")
    check("viewer: заголовок «IP видеонаблюдение»", "IP видеонаблюдение" in html)
    check("viewer: нет чекбокса «Добавление данных»", "Добавление данных" not in html)
    check("viewer: нет ссылок редактирования", "edit=" not in html)
    check("viewer: нет формы удаления", 'name="action" value="delete"' not in html)

    status, html, _ = fetch(viewer_op, page_url("Analog", "12", "3"))
    check("viewer: Analog → 200, колонка регистратора",
          status == 200 and "Видеорегистратор (расположение)" in html
          and "Сервер/РС" not in html, f"status={status}")

    viewer_token = token_from(html)
    status, _, _ = fetch(viewer_op, page_url("IP"), insert_payload(viewer_token))
    check("viewer: POST добавления → 403", status == 403, f"status={status}")
    status, _, _ = fetch(viewer_op, page_url("IP"),
                         {"_csrf": viewer_token, "action": "delete", "id": "2"})
    check("viewer: POST удаления → 403", status == 403, f"status={status}")
    status, _ = post_multipart(viewer_op, "/VideoIP/upload",
                               {"_csrf": viewer_token},
                               {"file": ("x.png", PNG_BYTES)})
    check("viewer: загрузка файла → 403", status == 403, f"status={status}")

    # ---------------- значения по умолчанию и фильтры (admin)
    status, html, _ = fetch(admin_op, "/VideoIP.aspx?VideoType=IP")
    check("admin: IP по умолчанию → 200", status == 200, f"status={status}")
    check("admin: есть чекбокс «Добавление данных»", "Добавление данных" in html)
    check("admin: цех по умолчанию — ЛПК (8 отсутствует в NameShop)",
          '<option value="3" selected>' in html)
    check("admin: пролет по умолчанию — второй пункт (0)",
          '<option value="0" selected>' in html)
    check("admin: 1 запись по умолчанию, заголовки IP-набора",
          "Всего записей: 1" in html
          and "Сервер/РС" in html
          and "Вывод изображения расположение/РС" in html
          and "Видеорегистратор (расположение)" not in html)

    status, html, _ = fetch(admin_op, "/VideoIP.aspx?VideoType=Analog")
    check("admin: Analog по умолчанию → пусто, текст-заглушка",
          status == 200 and "Данные по выбранному пролету отсутствуют" in html
          and "Всего записей: 0" in html)

    status, html, _ = fetch(admin_op, page_url("Analog", "11", "0"))
    check("Analog, цех=11, пролет=0 → 10 записей",
          status == 200 and "Всего записей: 10" in html, f"status={status}")
    check("Analog: нет колонок IP адрес/Сервер/РС",
          "<th>IP адрес</th>" not in html and "Сервер/РС" not in html)
    check("Analog: есть колонка «Монитор»", "<th>Монитор</th>" in html)

    status, html, _ = fetch(admin_op, page_url("IP", "12", "3"))
    check("IP, цех=12 (ТЭСЦ-5), пролет=3 → 6 записей",
          status == 200 and "Всего записей: 6" in html, f"status={status}")

    status, html, _ = fetch(admin_op, page_url("IP", "11", "-1"))
    check("Изображение камеры: ссылка /uploads/… (значение из БД)",
          "/uploads/Funny_Frog2.jpg" in html)
    status, body, _ = fetch(admin_op, "/uploads/Funny_Frog2.jpg")
    check("Файл изображения отдаётся → 200", status == 200, f"status={status}")

    status, html, _ = fetch(admin_op, "/VideoIP.aspx")
    check("без VideoType → таблица скрыта",
          status == 200 and "Выберите вид видеонаблюдения" in html
          and "class=\"grid grid--video\"" not in html)
    status, html, _ = fetch(admin_op, "/VideoIP.aspx?VideoType=zzz")
    check("неизвестный VideoType → таблица скрыта",
          status == 200 and "Выберите вид видеонаблюдения" in html)
    status, html, _ = fetch(admin_op, "/VideoAnalog.aspx")
    check("/VideoAnalog.aspx → 200, картинка /images/upsi.jpg",
          status == 200 and "/images/upsi.jpg" in html, f"status={status}")
    status, html, _ = fetch(admin_op, "/VideoIP.aspx?VideoType=IP&shop=999&prolet=zzz")
    check("некорректные параметры → значения по умолчанию",
          status == 200 and '<option value="3" selected>' in html
          and '<option value="0" selected>' in html)

    # ---------------- editor: добавление
    editor_op = make_opener()
    check("Вход test_editor", login(editor_op, "test_editor", "editor123"))

    _, html, _ = fetch(editor_op, page_url("IP"))
    token = token_from(html)

    status, _, _ = fetch(editor_op, page_url("IP"), insert_payload(""))
    check("POST без CSRF → 400", status == 400, f"status={status}")

    status, _, _ = fetch(editor_op, page_url("IP"), insert_payload(token, Oc="abc"))
    check("Нечисловая ось → редирект", status in (301, 302), f"status={status}")
    _, html, _ = fetch(editor_op, page_url("IP"))
    check("Нечисловая ось → сообщение «Введите число»", "Введите число" in html)
    conn = db()
    count = conn.execute('SELECT COUNT(*) FROM "Video_Camera_all"').fetchone()[0]
    conn.close()
    check("Нечисловая ось → запись не добавлена", count == 117, f"count={count}")

    status, _, _ = fetch(editor_op, page_url("IP"), insert_payload(token, Oc="5000"))
    _, html, _ = fetch(editor_op, page_url("IP"))
    check("Ось вне диапазона → сообщение, без записи",
          "Введите число" in html)

    status, _, _ = fetch(editor_op, page_url("IP"), insert_payload(token))
    check("Добавление → редирект", status in (301, 302), f"status={status}")
    _, html, _ = fetch(editor_op, page_url("IP"))
    check("Добавление → сообщение «Запись добавлена.»", "Запись добавлена." in html)
    check("Добавление → новая строка в списке", TEST_MARK in html)

    conn = db()
    row = conn.execute('SELECT * FROM "Video_Camera_all" WHERE "Uchastok" = ?',
                       (TEST_MARK,)).fetchone()
    check("Запись сохранена в БД", row is not None)
    check("Поля добавления сохранены верно",
          row is not None and row["ShopID"] == 11 and row["Prolet"] == 0
          and row["Oc"] == 77 and row["Camera_Type"] == "IP"
          and row["IDCAM_NAME"] == 1 and row["ID_CISCO"] == 1
          and row["IPaddress"] == "10.99.99.99"
          and row["upload_img"] == f"uploads/{TEST_UPLOAD}"
          and row["CISCO"] is None)
    row_id = row["ID_VID_CAM"] if row else None
    total = conn.execute('SELECT COUNT(*) FROM "Video_Camera_all"').fetchone()[0]
    conn.close()
    check("Всего строк Video_Camera_all = 118", total == 118, f"total={total}")

    # ---------------- editor: редактирование
    status, html, _ = fetch(editor_op, page_url("IP") + f"&edit={row_id}")
    check("Строка открыта на редактирование",
          status == 200 and 'id="edit-form"' in html, f"status={status}")
    token = token_from(html)
    update = {
        "_csrf": token,
        "action": "update",
        "id": str(row_id),
        "ShopID": "11",
        "Prolet": "0",
        "Uchastok": TEST_MARK,
        "Oc": "78",
        "IPaddress": "10.99.99.98",
        "Camera_number": "Изменённая камера",
        "IDCAM_NAME": "2",
        "IP_Server_PC": "10.99.99.2",
        "IP_CAMERA_STREAM": "http://example.local/stream2",
        "Login_password": "root/test2",
        "ID_CISCO": "2",
        "Port_CISCO": "Gi0/2",
        "Video_out_lacation_PC": "Изменённый регистратор",
        "Monitor": "TEST-MON-2",
        "Opisanie": "изменённое примечание",
        "upload_img": f"uploads/{TEST_UPLOAD}",
    }
    status, _, _ = fetch(editor_op, page_url("IP"), update)
    check("Сохранение изменений → редирект", status in (301, 302), f"status={status}")

    conn = db()
    row = conn.execute('SELECT * FROM "Video_Camera_all" WHERE "ID_VID_CAM" = ?',
                       (row_id,)).fetchone()
    check("Изменения записаны",
          row["Oc"] == 78 and row["Uchastok"] == TEST_MARK
          and row["Camera_number"] == "Изменённая камера"
          and row["IDCAM_NAME"] == 2 and row["ID_CISCO"] == 2
          and row["IPaddress"] == "10.99.99.98"
          and row["Monitor"] == "TEST-MON-2")
    check("CISCO сбрасывается в пустую строку (как в оригинале)",
          row["CISCO"] == "")
    conn.close()

    # ---------------- editor: загрузка изображения
    status, body = post_multipart(editor_op, "/VideoIP/upload",
                                  {"_csrf": token},
                                  {"file": (TEST_UPLOAD, PNG_BYTES)})
    data = json.loads(body) if body.startswith("{") else {}
    check("Загрузка .png → 200 и путь uploads/…",
          status == 200 and data.get("ok") is True
          and data.get("path") == f"uploads/{TEST_UPLOAD}", f"status={status} {body[:80]}")
    check("Файл сохранён в uploads/",
          os.path.exists(os.path.join(UPLOAD_DIR, TEST_UPLOAD)))

    status, body = post_multipart(editor_op, "/VideoIP/upload",
                                  {"_csrf": token},
                                  {"file": ("bad.txt", b"text")})
    data = json.loads(body) if body.startswith("{") else {}
    check("Недопустимое расширение → сообщение как в оригинале",
          status == 400 and data.get("message") == "Только файлы с расширением .png или .jpeg",
          f"status={status} {body[:80]}")

    status, body = post_multipart(editor_op, "/VideoIP/upload",
                                  {"_csrf": token},
                                  {"file": ("big.png", b"0" * (4 * 1024 * 1024 + 100))})
    check("Файл больше 4 МБ → 413", status == 413, f"status={status}")

    # ---------------- editor: удаление
    status, _, _ = fetch(editor_op, page_url("IP"),
                         {"_csrf": token, "action": "delete", "id": str(row_id)})
    check("Удаление → редирект", status in (301, 302), f"status={status}")
    conn = db()
    left = conn.execute('SELECT COUNT(*) FROM "Video_Camera_all" WHERE "Uchastok" = ?',
                        (TEST_MARK,)).fetchone()[0]
    total = conn.execute('SELECT COUNT(*) FROM "Video_Camera_all"').fetchone()[0]
    conn.close()
    check("Тестовая запись удалена", left == 0, f"left={left}")
    check("Количество строк Video_Camera_all = 117", total == 117, f"total={total}")

    status, html, _ = fetch(editor_op, page_url("IP") + "&edit=999999")
    check("Несуществующий edit → страница без формы правки",
          status == 200 and 'id="edit-form"' not in html, f"status={status}")

    cleanup()
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    for name, _, extra in failed:
        print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
