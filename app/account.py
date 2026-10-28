"""Смена собственного пароля. URL: /Account.aspx.

Пароль любого пользователя может сменить администратор (раздел
«Пользователи»), но каждый вошедший должен иметь возможность сменить свой
пароль сам, не раскрывая его администратору.
"""
from __future__ import annotations

from flask import Blueprint, flash, g, redirect, render_template, request, url_for
from werkzeug.security import check_password_hash, generate_password_hash

from .audit import log_action
from .db import get_db
from .security import login_required, validate_csrf
from .users import MIN_PASSWORD_LENGTH

bp = Blueprint("account", __name__)


@bp.route("/Account.aspx", methods=("GET", "POST"))
@login_required
def index():
    error = None

    if request.method == "POST":
        validate_csrf()

        current_password = request.form.get("current_password") or ""
        new_password = request.form.get("new_password") or ""
        repeat_password = request.form.get("repeat_password") or ""

        db = get_db()
        user = db.execute(
            "SELECT * FROM users WHERE user_id = ?", (g.user["user_id"],)
        ).fetchone()

        if user is None:
            error = "Пользователь не найден. Войдите заново."
        elif not check_password_hash(user["password_hash"], current_password):
            error = "Текущий пароль указан неверно."
        elif len(new_password) < MIN_PASSWORD_LENGTH:
            error = (
                f"Пароль должен быть не короче {MIN_PASSWORD_LENGTH} символов."
            )
        elif new_password == current_password:
            error = "Новый пароль должен отличаться от текущего."
        elif new_password != repeat_password:
            error = "Новые пароли не совпадают."
        else:
            db.execute(
                "UPDATE users SET password_hash = ? WHERE user_id = ?",
                (generate_password_hash(new_password), user["user_id"]),
            )
            db.commit()
            log_action(
                "password",
                "users",
                user["user_id"],
                f"Пользователь «{user['username']}» сменил свой пароль",
            )
            flash("Пароль изменён. Используйте его при следующем входе.", "success")
            return redirect(url_for("account.index"))

    return render_template("account.html", error=error)
