"""Сквозной тест аутентификации и RBAC (Этап 3).

Запускает HTTP-запросы к работающему серверу http://127.0.0.1:5000
и проверяет: вход, выход, CSRF, роли, управление пользователями.

Запуск:  python tools/test_auth.py
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


def table_row(html: str, marker: str) -> str:
    """Вернуть HTML-блок <tr>...</tr>, содержащий указанный текст."""
    for row in re.findall(r"<tr[^>]*>.*?</tr>", html, re.S):
        if marker in row:
            return row
    return ""


def cleanup_test_users() -> None:
    """Удалить тестовые учётки от предыдущих прогонов (не легаси-данные)."""
    if not os.path.exists(DB_PATH):
        return
    conn = sqlite3.connect(DB_PATH)
    conn.execute("DELETE FROM users WHERE username IN ('test_viewer', 'test_short')")
    conn.commit()
    conn.close()

results = []


def check(name: str, ok: bool, extra: str = "") -> None:
    results.append((name, ok, extra))
    print(f"{'OK  ' if ok else 'FAIL'} {name}{(' — ' + extra) if extra else ''}")


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def make_opener():
    jar = http.cookiejar.CookieJar()
    return urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(jar), NoRedirect()
    ), jar


def fetch(opener, path, data=None, method=None):
    url = BASE + path
    body = urllib.parse.urlencode(data).encode() if data is not None else None
    req = urllib.request.Request(url, data=body, method=method)
    try:
        with opener.open(req) as resp:
            return resp.status, resp.read().decode("utf-8", "replace"), resp.headers
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace"), exc.headers


def token_from(html: str) -> str:
    m = CSRF_RE.search(html)
    return m.group(1) if m else ""


def main() -> int:
    cleanup_test_users()

    # --- 1. Анонимный доступ
    op, _ = make_opener()
    status, _, headers = fetch(op, "/")
    check("/ без входа → редирект на login",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    status, html, _ = fetch(op, "/Login.aspx")
    check("GET /Login.aspx → 200 и форма", status == 200 and "Авторизация" in html)

    status, _, headers = fetch(op, "/admin/users/")
    check("Анонимный /admin/users → редирект на login",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""),
          f"status={status}")

    # --- 2. CSRF
    status, html, _ = fetch(op, "/Login.aspx")
    status, _, _ = fetch(op, "/Login.aspx", {"Login": "admin", "Pass": "11111111"})
    check("POST без CSRF-токена → 400", status == 400, f"status={status}")

    # --- 3. Неверный пароль
    token = token_from(html)
    status, html, _ = fetch(op, "/Login.aspx",
                            {"_csrf": token, "Login": "admin", "Pass": "wrong-pass"})
    check("Неверный пароль → сообщение об ошибке",
          status == 200 and "А вот и не угадал" in html,
          f"status={status}")
    check("Ошибка входа не раскрывает, существует ли пользователь",
          "не существует" not in html and "нет такого" not in html.lower())

    # --- 4. Успешный вход админом
    status, html, _ = fetch(op, "/Login.aspx")
    token = token_from(html)
    status, _, headers = fetch(op, "/Login.aspx",
                               {"_csrf": token, "Login": "admin", "Pass": "11111111"})
    check("Вход admin/11111111 → редирект", status in (301, 302), f"status={status}")

    status, html, _ = fetch(op, "/")
    check("Главная после входа → 200, показан пользователь",
          status == 200 and "admin" in html)

    status, html, _ = fetch(op, "/admin/users/")
    check("admin видит /admin/users → 200", status == 200 and "Пользователи и роли" in html)

    # --- 5. Создание viewer
    token = token_from(html)
    status, _, _ = fetch(op, "/admin/users/create",
                         {"_csrf": token, "username": "test_viewer",
                          "password": "viewer123", "role": "viewer"})
    check("Создание пользователя test_viewer", status in (301, 302), f"status={status}")

    status, html, _ = fetch(op, "/admin/users/")
    check("test_viewer отображается в списке", "test_viewer" in html)

    # --- 6. Дубликат логина
    token = token_from(html)
    status, _, _ = fetch(op, "/admin/users/create",
                         {"_csrf": token, "username": "test_viewer",
                          "password": "viewer123", "role": "viewer"})
    status, html, _ = fetch(op, "/admin/users/")
    check("Дубликат логина отклонён", "уже существует" in html)

    # --- 7. Короткий пароль
    token = token_from(html)
    fetch(op, "/admin/users/create",
          {"_csrf": token, "username": "test_short", "password": "123", "role": "viewer"})
    status, html, _ = fetch(op, "/admin/users/")
    check("Короткий пароль отклонён", "не короче 6" in html)
    check("Пользователь test_short не создан", "test_short" not in html)

    # --- 8. Вход viewer и проверка прав
    vop, _ = make_opener()
    status, html, _ = fetch(vop, "/Login.aspx")
    token = token_from(html)
    status, _, _ = fetch(vop, "/Login.aspx",
                         {"_csrf": token, "Login": "test_viewer", "Pass": "viewer123"})
    check("Вход test_viewer → редирект", status in (301, 302), f"status={status}")

    status, html, _ = fetch(vop, "/")
    check("viewer видит главную", status == 200 and "test_viewer" in html)

    status, _, _ = fetch(vop, "/admin/users/")
    check("viewer → /admin/users запрещено (403)", status == 403, f"status={status}")

    status, _, _ = fetch(vop, "/admin/users/create",
                         {"_csrf": token, "username": "hack", "password": "hack123", "role": "admin"})
    check("viewer не может создать пользователя (403)", status == 403, f"status={status}")

    # --- 9. Выход
    status, html, _ = fetch(vop, "/")
    token = token_from(html)
    status, _, headers = fetch(vop, "/logout", {"_csrf": token})
    check("Выход → редирект на login", status in (301, 302), f"status={status}")
    status, _, headers = fetch(vop, "/")
    check("После выхода главная недоступна",
          status in (301, 302) and "/Login.aspx" in (headers.get("Location") or ""))

    # --- 10. Блокировка пользователя
    status, html, _ = fetch(op, "/admin/users/")
    row_block = table_row(html, "test_viewer")
    m_id = re.search(r"/admin/users/(\d+)/", row_block) if row_block else None
    viewer_id = m_id.group(1) if m_id else None

    if viewer_id:
        token = token_from(html)
        fetch(op, f"/admin/users/{viewer_id}/toggle", {"_csrf": token})
        blocked_op, _ = make_opener()
        status, vhtml, _ = fetch(blocked_op, "/Login.aspx")
        token = token_from(vhtml)
        status, vhtml, _ = fetch(blocked_op, "/Login.aspx",
                                 {"_csrf": token, "Login": "test_viewer", "Pass": "viewer123"})
        check("Заблокированный пользователь не может войти",
              status == 200 and "А вот и не угадал" in vhtml)
    else:
        check("Определение ID test_viewer", False, "не найден")

    # --- 11. Смена роли
    if viewer_id:
        status, html, _ = fetch(op, "/admin/users/")
        token = token_from(html)
        fetch(op, f"/admin/users/{viewer_id}/role", {"_csrf": token, "role": "editor"})
        status, html, _ = fetch(op, "/admin/users/")
        block = table_row(html, "test_viewer")
        check("Смена роли viewer → editor",
              bool(block) and 'value="editor" selected' in block)
    else:
        check("Определение ID test_viewer", False, "не найден")

    # --- 12. Самоблокировка администратора запрещена
    status, html, _ = fetch(op, "/admin/users/")
    token = token_from(html)
    admin_block = table_row(html, "(вы)")
    admin_id = None
    if admin_block:
        m_id = re.search(r"/admin/users/(\d+)/", admin_block)
        admin_id = m_id.group(1) if m_id else None
    if admin_id:
        fetch(op, f"/admin/users/{admin_id}/toggle", {"_csrf": token})
        status, html, _ = fetch(op, "/admin/users/")
        check("Нельзя заблокировать самого себя", "самого себя" in html)
    else:
        check("Определение ID admin", False, "не найден")

    # --- 13. Очистка тестового пользователя (деактивируем, не удаляем по правилам)
    print()
    failed = [r for r in results if not r[1]]
    print(f"ИТОГО: {len(results) - len(failed)}/{len(results)} проверок пройдено")
    if failed:
        print("ПРОВАЛЕНО:")
        for name, _, extra in failed:
            print("  -", name, extra)
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
