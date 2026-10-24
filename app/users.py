"""Управление пользователями и ролями. Доступ — только admin."""
from __future__ import annotations

from flask import Blueprint, abort, flash, g, redirect, render_template, request, url_for
from werkzeug.security import generate_password_hash

from .db import get_db
from .security import roles_required, validate_csrf

bp = Blueprint("users", __name__, url_prefix="/admin/users")

VALID_ROLES = ("viewer", "editor", "admin")
MIN_PASSWORD_LENGTH = 6


def _get_user_or_404(user_id: int):
    user = get_db().execute(
        "SELECT * FROM users WHERE user_id = ?", (user_id,)
    ).fetchone()
    if user is None:
        abort(404)
    return user


def _active_admins_count() -> int:
    return get_db().execute(
        "SELECT COUNT(*) FROM users WHERE role = 'admin' AND is_active = 1"
    ).fetchone()[0]


@bp.route("/", methods=("GET",))
@roles_required("admin")
def index():
    users = get_db().execute(
        "SELECT * FROM users ORDER BY username COLLATE NOCASE"
    ).fetchall()
    return render_template("users.html", users=users, valid_roles=VALID_ROLES)


@bp.route("/create", methods=("POST",))
@roles_required("admin")
def create():
    validate_csrf()
    db = get_db()

    username = (request.form.get("username") or "").strip()
    password = request.form.get("password") or ""
    role = request.form.get("role") or "viewer"

    error = None
    if not username:
        error = "Укажите имя пользователя."
    elif len(password) < MIN_PASSWORD_LENGTH:
        error = f"Пароль должен быть не короче {MIN_PASSWORD_LENGTH} символов."
    elif role not in VALID_ROLES:
        error = "Недопустимая роль."
    elif db.execute(
        "SELECT 1 FROM users WHERE username = ? COLLATE NOCASE", (username,)
    ).fetchone():
        error = f"Пользователь «{username}» уже существует."

    if error:
        flash(error, "error")
    else:
        db.execute(
            "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)",
            (username, generate_password_hash(password), role),
        )
        db.commit()
        flash(f"Пользователь «{username}» создан с ролью {role}.", "success")

    return redirect(url_for("users.index"))


@bp.route("/<int:user_id>/role", methods=("POST",))
@roles_required("admin")
def change_role(user_id: int):
    validate_csrf()
    db = get_db()
    user = _get_user_or_404(user_id)
    role = request.form.get("role") or ""

    if role not in VALID_ROLES:
        flash("Недопустимая роль.", "error")
        return redirect(url_for("users.index"))

    # Нельзя снять с себя права администратора, если это последний активный админ.
    if (
        user["user_id"] == g.user["user_id"]
        and user["role"] == "admin"
        and role != "admin"
        and _active_admins_count() <= 1
    ):
        flash("Нельзя снять роль admin с последнего администратора.", "error")
        return redirect(url_for("users.index"))

    db.execute("UPDATE users SET role = ? WHERE user_id = ?", (role, user_id))
    db.commit()
    flash(f"Роль пользователя «{user['username']}» изменена на {role}.", "success")
    return redirect(url_for("users.index"))


@bp.route("/<int:user_id>/password", methods=("POST",))
@roles_required("admin")
def reset_password(user_id: int):
    validate_csrf()
    user = _get_user_or_404(user_id)
    password = request.form.get("password") or ""

    if len(password) < MIN_PASSWORD_LENGTH:
        flash(
            f"Пароль должен быть не короче {MIN_PASSWORD_LENGTH} символов.", "error"
        )
        return redirect(url_for("users.index"))

    db = get_db()
    db.execute(
        "UPDATE users SET password_hash = ? WHERE user_id = ?",
        (generate_password_hash(password), user_id),
    )
    db.commit()
    flash(f"Пароль пользователя «{user['username']}» изменён.", "success")
    return redirect(url_for("users.index"))


@bp.route("/<int:user_id>/toggle", methods=("POST",))
@roles_required("admin")
def toggle_active(user_id: int):
    validate_csrf()
    db = get_db()
    user = _get_user_or_404(user_id)

    if user["user_id"] == g.user["user_id"]:
        flash("Нельзя заблокировать самого себя.", "error")
        return redirect(url_for("users.index"))

    if user["is_active"] and user["role"] == "admin" and _active_admins_count() <= 1:
        flash("Нельзя заблокировать последнего администратора.", "error")
        return redirect(url_for("users.index"))

    new_state = 0 if user["is_active"] else 1
    db.execute("UPDATE users SET is_active = ? WHERE user_id = ?", (new_state, user_id))
    db.commit()
    action = "разблокирован" if new_state else "заблокирован"
    flash(f"Пользователь «{user['username']}» {action}.", "success")
    return redirect(url_for("users.index"))
