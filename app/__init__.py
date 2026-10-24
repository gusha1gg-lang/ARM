"""Фабрика Flask-приложения ARM-OMK.

Этап 2: каркас и БД.
Этап 3: аутентификация, роли, управление пользователями.
Маршруты страниц справочника добавляются на Этапе 4.
"""
import os
import sqlite3

from flask import Flask, g, jsonify, redirect, render_template, request, send_from_directory, url_for

from . import (
    auth,
    cisco,
    db,
    ipaddr4,
    ipaddr5,
    ipaddr_all,
    ipaddr_uch,
    jarlik,
    security,
    spr,
    static_pages,
    telefon,
    users,
    video,
)
from .config import BASE_DIR, Config


def create_app(config_object=Config) -> Flask:
    app = Flask(__name__)
    app.config.from_object(config_object)

    os.makedirs(os.path.dirname(app.config["DATABASE"]), exist_ok=True)
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

    db.init_app(app)
    security.init_app(app)

    app.register_blueprint(auth.bp)
    app.register_blueprint(users.bp)
    app.register_blueprint(ipaddr4.bp)
    app.register_blueprint(ipaddr5.bp)
    app.register_blueprint(ipaddr_uch.bp)
    app.register_blueprint(ipaddr_all.bp)
    app.register_blueprint(video.bp)
    app.register_blueprint(telefon.bp)
    app.register_blueprint(cisco.bp)
    app.register_blueprint(jarlik.bp)
    app.register_blueprint(spr.bp)
    app.register_blueprint(static_pages.bp)

    @app.route("/")
    def index():
        # Как в оригинале: после входа открывается main.aspx.
        if g.user is None:
            return redirect(url_for("auth.login"))
        return redirect(url_for("ipaddr4.main"))

    # Legacy-ресурсы оригинального сайта (не дублируем файлы, отдаём как есть).
    @app.route("/img/<path:filename>")
    def legacy_img(filename):
        return send_from_directory(BASE_DIR / "img", filename)

    @app.route("/css/<path:filename>")
    def legacy_css(filename):
        return send_from_directory(BASE_DIR / "css", filename)

    @app.route("/images/<path:filename>")
    def legacy_images(filename):
        return send_from_directory(BASE_DIR / "images", filename)

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
        path = request.path.rstrip("/") or "/"
        if path.lower().endswith((".aspx", ".htm", ".html")):
            message = (
                "Этот раздел ещё не перенесён на новую версию "
                "(Этап 4 выполняется постранично)."
            )
        else:
            message = "Страница не найдена."
        return render_template("error.html", code=404, message=message), 404

    return app
