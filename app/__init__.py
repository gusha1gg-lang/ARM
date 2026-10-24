"""Фабрика Flask-приложения ARM-OMK.

Этап 2: каркас и БД. Маршруты страниц добавляются на Этапе 4.
"""
import os
import sqlite3

from flask import Flask, jsonify

from . import db
from .config import Config


def create_app(config_object=Config) -> Flask:
    app = Flask(__name__)
    app.config.from_object(config_object)

    os.makedirs(os.path.dirname(app.config["DATABASE"]), exist_ok=True)
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

    db.init_app(app)

    @app.route("/health")
    def health():
        """Самопроверка: приложение живо и БД доступна."""
        try:
            conn = db.get_db()
            tables = [
                r["name"]
                for r in conn.execute(
                    "SELECT name FROM sqlite_master "
                    "WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"
                )
            ]
            counts = {
                t: conn.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
                for t in tables
            }
            return jsonify(status="ok", database=app.config["DATABASE"], tables=counts)
        except sqlite3.Error as exc:
            return jsonify(status="error", error=str(exc)), 500

    return app
