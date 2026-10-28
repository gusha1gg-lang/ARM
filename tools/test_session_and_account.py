"""Проверка суточного таймаута сессии и смены своего пароля.

Работает внутри процесса (Flask test_client), сервер запускать не нужно:
    python tools/test_session_and_account.py

Тест создаёт собственного пользователя ARM-SESSION-TEST и удаляет его в конце.
"""
from __future__ import annotations

import re
import sqlite3
import sys
import time
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR))

# Библиотеки лежат в vendor/ — на сервере pip нет.
VENDOR_DIR = BASE_DIR / "vendor"
if VENDOR_DIR.is_dir():
    sys.path.insert(0, str(VENDOR_DIR))

from werkzeug.security import check_password_hash  # noqa: E402

from app import create_app  # noqa: E402
from app.config import Config  # noqa: E402

CSRF_RE = re.compile(r'name="_csrf" value="([^"]+)"')
LOGIN = "ARM-SESSION-TEST"
MARKER = "ARM-SESSION-TEST"
DB_PATH = Config.DATABASE

DAY = 24 * 60 * 60
passed = 0
failed = 0


def check(name: str, ok: bool, extra: str = "") -> None:
    global passed, failed
    if ok:
        passed += 1
    else:
        failed += 1
    print(f"{'OK  ' if ok else 'FAIL'} {name}{(' - ' + extra) if extra else ''}")


def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def cleanup() -> None:
    conn = db()
    conn.execute("DELETE FROM users WHERE username = ?", (LOGIN,))
    conn.execute("DELETE FROM audit_log WHERE details LIKE ?", (f"%{MARKER}%",))
    conn.commit()
    conn.close()


def create_user(password: str) -> None:
    from werkzeug.security import generate_password_hash

    cleanup()
    conn = db()
    conn.execute(
        "INSERT INTO users (username, password_hash, role) VALUES (?, ?, 'viewer')",
        (LOGIN, generate_password_hash(password)),
    )
    conn.commit()
    conn.close()


def token(client, path: str = "/Login.aspx") -> str:
    match = CSRF_RE.search(client.get(path).get_data(as_text=True))
    return match.group(1) if match else ""


def login(client, password: str):
    return client.post(
        "/Login.aspx",
        data={"_csrf": token(client), "Login": LOGIN, "Pass": password},
    )


def main() -> int:
    app = create_app()
    app.config.update(TESTING=True)

    create_user("oldpass123")
    client = app.test_client()

    # ---------------------------------------------------- вход и сессия
    response = login(client, "oldpass123")
    check("вход выполнен", response.status_code == 302,
          f"status={response.status_code}")

    with client.session_transaction() as sess:
        check("сессия помечена как постоянная", bool(sess.permanent))
        check("в сессии есть время входа", "login_at" in sess)
        login_at = sess.get("login_at")

    client.get("/")
    with client.session_transaction() as sess:
        check("время входа не сдвигается при запросах",
              sess.get("login_at") == login_at)

    # ---------------------------------------------------- смена пароля
    response = client.get("/Account.aspx")
    page = response.get_data(as_text=True)
    check("страница смены пароля открывается", response.status_code == 200,
          f"status={response.status_code}")
    check("на странице есть заголовок", "Смена своего пароля" in page)
    check("в шапке есть ссылка «Сменить пароль»",
          "Сменить пароль" in client.get("/", follow_redirects=True)
          .get_data(as_text=True))

    form = {"_csrf": token(client, "/Account.aspx")}

    response = client.post("/Account.aspx", data={
        **form, "current_password": "wrong", "new_password": "newpass123",
        "repeat_password": "newpass123"})
    check("неверный текущий пароль отклонён",
          "Текущий пароль указан неверно" in response.get_data(as_text=True))

    response = client.post("/Account.aspx", data={
        **form, "current_password": "oldpass123", "new_password": "12345",
        "repeat_password": "12345"})
    check("короткий пароль отклонён",
          "не короче 6 символов" in response.get_data(as_text=True))

    response = client.post("/Account.aspx", data={
        **form, "current_password": "oldpass123", "new_password": "oldpass123",
        "repeat_password": "oldpass123"})
    check("новый пароль, равный текущему, отклонён",
          "должен отличаться от текущего" in response.get_data(as_text=True))

    response = client.post("/Account.aspx", data={
        **form, "current_password": "oldpass123", "new_password": "newpass123",
        "repeat_password": "newpass456"})
    check("несовпадение повтора отклонено",
          "не совпадают" in response.get_data(as_text=True))

    response = client.post("/Account.aspx", data={
        **form, "current_password": "oldpass123", "new_password": "newpass123",
        "repeat_password": "newpass123"})
    check("пароль изменён", response.status_code == 302,
          f"status={response.status_code}")

    conn = db()
    row = conn.execute("SELECT password_hash FROM users WHERE username = ?",
                       (LOGIN,)).fetchone()
    conn.close()
    check("в БД новый хеш пароля", check_password_hash(row["password_hash"],
                                                       "newpass123"))

    check("в журнале есть запись о смене пароля", _in_log("password"))

    # ---------------------------------------------------- вход новым паролем
    fresh = app.test_client()
    response = login(fresh, "newpass123")
    check("вход с новым паролем работает", response.status_code == 302,
          f"status={response.status_code}")

    old = app.test_client()
    response = old.post("/Login.aspx", data={
        "_csrf": token(old), "Login": LOGIN, "Pass": "oldpass123"})
    check("старый пароль больше не подходит",
          "Доступ ограничен" in response.get_data(as_text=True))

    # ---------------------------------------------------- истечение суток
    with client.session_transaction() as sess:
        sess["login_at"] = time.time() - DAY - 60

    response = client.get("/")
    check("просроченная сессия → вход",
          response.status_code == 302 and "/Login.aspx" in response.headers["Location"],
          f"status={response.status_code} {response.headers.get('Location')}")
    with client.session_transaction() as sess:
        check("просроченная сессия очищена", "user_id" not in sess)

    with client.session_transaction() as sess:
        sess["user_id"] = _user_id()
        sess["login_at"] = time.time() - DAY + 600
        sess.permanent = True
    response = client.get("/")
    check("сессия моложе суток продолжает работать",
          response.status_code == 302 and "/Login.aspx" not in response.headers.get("Location", ""),
          f"status={response.status_code}")

    # ---------------------------------------------------- /health
    health = app.test_client().get("/health")
    body = health.get_data(as_text=True)
    check("/health отвечает", health.status_code == 200, f"status={health.status_code}")
    check("/health не выдаёт путь к БД и таблицы",
          "database" not in body and "asutp" not in body)

    cleanup()
    print()
    print(f"ИТОГО: {passed}/{passed + failed} проверок пройдено")
    return 0 if failed == 0 else 1


def _user_id() -> int:
    conn = db()
    row = conn.execute("SELECT user_id FROM users WHERE username = ?",
                       (LOGIN,)).fetchone()
    conn.close()
    return row["user_id"]


def _in_log(action: str) -> bool:
    conn = db()
    row = conn.execute(
        "SELECT 1 FROM audit_log WHERE action = ? AND details LIKE ?",
        (action, f"%{MARKER}%"),
    ).fetchone()
    conn.close()
    return row is not None


if __name__ == "__main__":
    sys.exit(main())
