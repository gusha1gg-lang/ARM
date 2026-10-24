"""Фабрика Flask-приложения ARM-OMK.

Этап 2: каркас и БД.
Этап 3: аутентификация, роли, управление пользователями.
Маршруты страниц справочника добавляются на Этапе 4.
"""
import os
import sqlite3

from flask import Flask, g, jsonify, redirect, render_template, url_for

from . import auth, db, security, users
from .config import Config


def create_app(config_object=Config) -> Flask:
    app = Flask(__name__)
    app.config.from_object(config_object)

    os.makedirs(os.path.dirname(app.config["DATABASE"]), exist_ok=True)
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

    db.init_app(app)
    security.init_app(app)

    app.register_blueprint(auth.bp)
    app.register_blueprint(users.bp)

    @app.route("/")
    def index():
        if g.user is None:
            return redirect(url_for("auth.login"))
        return render_template("index.html")

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

    @app.errorhandler(403)
    def forbidden(exc):
        return render_template("error.html", code=403,
                               message="Доступ запрещён: недостаточно прав."), 403

    @app.errorhandler(404)
    def not_found(exc):
        return render_template("error.html", code=404,
                               message="Страница не найдена."), 404

    return app
