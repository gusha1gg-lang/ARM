"""Вход и выход. URL сохранён как в оригинале: /Login.aspx."""
from __future__ import annotations

from flask import (
    Blueprint,
    g,
    redirect,
    render_template,
    request,
    session,
    url_for,
)
from werkzeug.security import check_password_hash

from .db import get_db
from .security import validate_csrf

bp = Blueprint("auth", __name__)

# Текст ошибки дословно из оригинала (Login.aspx, Label msg_label).
LOGIN_ERROR = "А вот и не угадал. Доступ ограничен."


def _safe_next(target: str | None) -> str | None:
    """Разрешать редирект только на локальные пути (защита от open redirect)."""
    if not target:
        return None
    if not target.startswith("/") or target.startswith("//"):
        return None
    if target.startswith("/Login.aspx"):
        return None
    return target


@bp.route("/Login.aspx", methods=("GET", "POST"))
def login():
    if g.user is not None:
        return redirect(url_for("index"))

    error = None

    if request.method == "POST":
        validate_csrf()

        login_name = (request.form.get("Login") or "").strip()
        password = request.form.get("Pass") or ""

        db = get_db()
        user = db.execute(
            "SELECT * FROM users WHERE username = ? COLLATE NOCASE",
            (login_name,),
        ).fetchone()

        if (
            user is None
            or not user["is_active"]
            or not check_password_hash(user["password_hash"], password)
        ):
            error = LOGIN_ERROR
        else:
            session.clear()
            session["user_id"] = user["user_id"]
            db.execute(
                "UPDATE users SET last_login = datetime('now') WHERE user_id = ?",
                (user["user_id"],),
            )
            db.commit()
            target = _safe_next(request.args.get("next"))
            return redirect(target or url_for("index"))

    return render_template("login.html", error=error)


@bp.route("/logout", methods=("POST",))
def logout():
    validate_csrf()
    session.clear()
    return redirect(url_for("auth.login"))
