"""Безопасность: текущий пользователь, RBAC-декораторы, CSRF.

Роли (из docs/01_PLAN.md):
    viewer — только просмотр;
    editor — просмотр + добавление/изменение/удаление данных;
    admin  — полный доступ, включая управление пользователями.
"""
from __future__ import annotations

import hmac
import secrets
import time
from functools import wraps

from flask import abort, current_app, g, redirect, request, session, url_for

from .db import get_db

# Порядок «старшинства» ролей — для проверки «не ниже чем».
ROLE_LEVEL = {"viewer": 1, "editor": 2, "admin": 3}

#: Значение по умолчанию, если PERMANENT_SESSION_LIFETIME не задан.
SESSION_LIFETIME_SECONDS = 24 * 60 * 60


def session_expired() -> bool:
    """Истёк ли срок сессии (1 сутки с момента входа, а не бездействия).

    Flask сам отбрасывает просроченную cookie, но её срок можно «сдвинуть»:
    любое изменение сессии (flash-сообщение, CSRF-токен) переподписывает
    cookie с новым сроком. Поэтому время входа хранится отдельно в
    ``session["login_at"]`` и проверяется явно.
    """
    login_at = session.get("login_at")
    if login_at is None:
        return True
    try:
        age = time.time() - float(login_at)
    except (TypeError, ValueError):
        return True
    lifetime = current_app.config.get("PERMANENT_SESSION_LIFETIME")
    seconds = lifetime.total_seconds() if lifetime else SESSION_LIFETIME_SECONDS
    return age > seconds


def load_logged_in_user() -> None:
    """Загрузить пользователя из сессии в g.user (или None)."""
    user_id = session.get("user_id")
    g.user = None
    if user_id is not None and session_expired():
        # Сутки с момента входа прошли — сессию закрываем.
        session.clear()
        user_id = None
    if user_id is not None:
        g.user = get_db().execute(
            "SELECT user_id, username, role, is_active, created_at, last_login "
            "FROM users WHERE user_id = ? AND is_active = 1",
            (user_id,),
        ).fetchone()
        if g.user is None:
            # Пользователь удалён или деактивирован — сбрасываем сессию.
            session.clear()


def login_required(view):
    """Страница доступна только вошедшим пользователям."""

    @wraps(view)
    def wrapped(*args, **kwargs):
        if g.user is None:
            return redirect(url_for("auth.login", next=request.full_path))
        return view(*args, **kwargs)

    return wrapped


def roles_required(*roles: str):
    """Разрешить просмотр только указанным ролям (403 для остальных)."""

    allowed = set(roles)

    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            if g.user is None:
                return redirect(url_for("auth.login", next=request.full_path))
            if g.user["role"] not in allowed:
                abort(403)
            return view(*args, **kwargs)

        return wrapped

    return decorator


def min_role(role: str):
    """Разрешить доступ ролям не ниже указанной."""
    level = ROLE_LEVEL[role]
    allowed = tuple(name for name, lvl in ROLE_LEVEL.items() if lvl >= level)
    return roles_required(*allowed)


# ---------------------------------------------------------------- CSRF


def csrf_token() -> str:
    """Вернуть (при необходимости создать) токен CSRF для текущей сессии."""
    if "_csrf" not in session:
        session["_csrf"] = secrets.token_urlsafe(32)
    return session["_csrf"]


def validate_csrf() -> None:
    """Проверить токен CSRF из формы. При несовпадении — 400."""
    expected = session.get("_csrf")
    received = request.form.get("_csrf", "")
    if not expected or not received or not hmac.compare_digest(expected, received):
        abort(400, description="Недействительный CSRF-токен. Обновите страницу и повторите.")


def init_app(app) -> None:
    app.before_request(load_logged_in_user)
    app.jinja_env.globals["csrf_token"] = csrf_token
    app.jinja_env.globals["ROLE_LEVEL"] = ROLE_LEVEL
