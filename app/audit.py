"""Журнал действий пользователей (аудит) и страница «Логи».

Функция добавлена по требованию пользователя (2026-10-28):
  * на сайте фиксируется, кто и когда что сделал;
  * в верхнем меню появился раздел «Логи»;
  * на формах редактирования справа от заголовка показывается, кто и когда
    последним изменял запись.

Таблица создаётся автоматически при старте приложения
(``ensure_schema``). Legacy-таблицы не затрагиваются.
"""
from __future__ import annotations

import math
import sqlite3

from flask import (
    Blueprint,
    current_app,
    g,
    render_template,
    request,
    url_for,
)

from .db import get_db
from .security import login_required

bp = Blueprint("audit", __name__)

#: Журнал действий. Время — локальное (datetime('now','localtime')),
#: чтобы в интерфейсе не было расхождения с часами пользователя.
SCHEMA = """
CREATE TABLE IF NOT EXISTS audit_log (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT NOT NULL DEFAULT (datetime('now','localtime')),
    user_id    INTEGER,
    username   TEXT NOT NULL,
    role       TEXT,
    action     TEXT NOT NULL,
    entity     TEXT NOT NULL,
    record_id  TEXT,
    details    TEXT,
    ip         TEXT
)
"""

INDEXES = (
    "CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_log(created_at DESC)",
    "CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_log(entity, record_id)",
    "CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_log(username)",
)

#: Человекочитаемые названия действий.
ACTION_LABELS = {
    "login": "Вход",
    "logout": "Выход",
    "create": "Добавление",
    "update": "Изменение",
    "delete": "Удаление",
    "role": "Смена роли",
    "password": "Смена пароля",
    "block": "Блокировка",
    "unblock": "Разблокировка",
    "rename": "Переименование",
    "upload": "Загрузка файла",
}

#: Сущности журнала → названия разделов сайта.
ENTITY_LABELS = {
    "IPaddress4": "ТЭСК ТБД",
    "IPaddress5": "ТЭСЦ 5",
    "IPAddressUch": "АБК",
    "IPaddressAll": "Все цеха",
    "Jarlik": "Ярлыки",
    "telefon": "Телефоны",
    "SPR_CISCO": "Справочник CISCO",
    "SPR_CAMERA": "Справочник камер",
    "NameShop": "Справочник цехов",
    "Video_Camera_all": "Видеонаблюдение",
    "users": "Пользователи",
    "auth": "Вход и выход",
}

#: Страница редактирования записи — для ссылок из журнала.
EDIT_ENDPOINTS = {
    "IPaddress4": "ipaddr4.edit",
    "IPaddress5": "ipaddr5.edit",
    "IPAddressUch": "ipaddr_uch.edit",
    "IPaddressAll": "ipaddr_all.edit",
    "Jarlik": "jarlik.edit",
}

PAGE_SIZE = 100


# ------------------------------------------------------------------ схема


def ensure_schema() -> None:
    """Создать таблицу журнала и индексы, если их ещё нет."""
    db = get_db()
    db.execute(SCHEMA)
    for statement in INDEXES:
        db.execute(statement)
    db.commit()


def init_app(app) -> None:
    """Создать таблицу при старте и зарегистрировать Jinja-фильтр."""
    with app.app_context():
        ensure_schema()

    app.jinja_env.filters["audit_dt"] = pretty_dt


# ------------------------------------------------------------- запись/чтение


def pretty_dt(value) -> str:
    """'2026-10-28 14:05:09' → '28.10.2026 14:05:09'."""
    if not value:
        return ""
    text = str(value)
    if len(text) >= 19 and text[4] == "-" and text[7] == "-":
        return f"{text[8:10]}.{text[5:7]}.{text[0:4]} {text[11:19]}"
    return text


def _field(user, key, index):
    """Достать поле пользователя из sqlite3.Row или словаря."""
    if user is None:
        return None
    try:
        return user[key]
    except (KeyError, IndexError, TypeError):
        pass
    try:
        return tuple(user)[index]
    except (IndexError, TypeError):
        return None


def log_action(
    action: str,
    entity: str,
    record_id=None,
    details: str | None = None,
    user=None,
) -> None:
    """Записать действие в журнал.

    ``user`` — строка пользователя (sqlite3.Row). Если не передана, берётся
    ``g.user`` (для входа передаём найденного пользователя явно, т.к. сессия
    ещё не установлена). Ошибки записи не должны ломать основное действие.
    """
    if user is None:
        user = g.get("user")

    try:
        db = get_db()
        db.execute(
            'INSERT INTO "audit_log" '
            '("user_id", "username", "role", "action", "entity", "record_id", '
            '"details", "ip") VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            (
                _field(user, "user_id", 0),
                _field(user, "username", 1) or "—",
                _field(user, "role", 2),
                action,
                entity,
                None if record_id is None else str(record_id),
                details,
                request.remote_addr,
            ),
        )
        db.commit()
    except sqlite3.Error:
        current_app.logger.exception("Не удалось записать действие в журнал")


def last_change(entity: str, record_id) -> sqlite3.Row | None:
    """Последнее изменение конкретной записи (или None)."""
    return get_db().execute(
        'SELECT "username", "role", "action", "created_at" FROM "audit_log" '
        'WHERE "entity" = ? AND "record_id" = ? AND "action" IN '
        "('create', 'update') ORDER BY \"id\" DESC LIMIT 1",
        (entity, str(record_id)),
    ).fetchone()


def record_url(entity: str, record_id) -> str | None:
    """Ссылка на форму редактирования записи из журнала (если есть)."""
    endpoint = EDIT_ENDPOINTS.get(entity)
    if endpoint is None or record_id in (None, ""):
        return None
    try:
        return url_for(endpoint, id=int(record_id))
    except (TypeError, ValueError):
        return None


# ------------------------------------------------------------------- страница


@bp.route("/Logs.aspx")
@login_required
def logs():
    db = get_db()

    filters = {
        "username": (request.args.get("username") or "").strip(),
        "entity": (request.args.get("entity") or "").strip(),
        "action": (request.args.get("action") or "").strip(),
        "date_from": (request.args.get("date_from") or "").strip(),
        "date_to": (request.args.get("date_to") or "").strip(),
    }

    where: list[str] = []
    params: list = []
    if filters["username"]:
        where.append('"username" = ?')
        params.append(filters["username"])
    if filters["entity"] in ENTITY_LABELS:
        where.append('"entity" = ?')
        params.append(filters["entity"])
    if filters["action"] in ACTION_LABELS:
        where.append('"action" = ?')
        params.append(filters["action"])
    if filters["date_from"]:
        where.append('date("created_at") >= date(?)')
        params.append(filters["date_from"])
    if filters["date_to"]:
        where.append('date("created_at") <= date(?)')
        params.append(filters["date_to"])

    clause = (" WHERE " + " AND ".join(where)) if where else ""

    total = db.execute(
        f'SELECT COUNT(*) FROM "audit_log"{clause}', params
    ).fetchone()[0]

    pages = max(1, math.ceil(total / PAGE_SIZE))
    try:
        page = int(request.args.get("page", "1"))
    except (TypeError, ValueError):
        page = 1
    page = min(max(page, 1), pages)

    rows = db.execute(
        f'SELECT * FROM "audit_log"{clause} ORDER BY "id" DESC LIMIT ? OFFSET ?',
        params + [PAGE_SIZE, (page - 1) * PAGE_SIZE],
    ).fetchall()

    usernames = [
        r[0]
        for r in db.execute(
            'SELECT DISTINCT "username" FROM "audit_log" '
            'WHERE "username" IS NOT NULL ORDER BY "username" COLLATE NOCASE'
        )
    ]

    active_filters = {k: v for k, v in filters.items() if v}

    return render_template(
        "logs.html",
        rows=rows,
        total=total,
        page=page,
        pages=pages,
        page_size=PAGE_SIZE,
        filters=filters,
        active_filters=active_filters,
        usernames=usernames,
        actions=ACTION_LABELS,
        entities=ENTITY_LABELS,
        record_url=record_url,
    )
