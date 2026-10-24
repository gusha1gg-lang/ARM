"""Доступ к SQLite для Flask (одно соединение на запрос)."""
import sqlite3

from flask import current_app, g


def get_db() -> sqlite3.Connection:
    """Вернуть соединение с БД, создав его при первом обращении в запросе."""
    if "db" not in g:
        conn = sqlite3.connect(current_app.config["DATABASE"])
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA foreign_keys = ON")
        g.db = conn
    return g.db


def close_db(exc=None) -> None:
    """Закрыть соединение в конце запроса."""
    conn = g.pop("db", None)
    if conn is not None:
        conn.close()


def init_app(app) -> None:
    app.teardown_appcontext(close_db)
