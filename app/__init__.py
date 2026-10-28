"""Фабрика Flask-приложения ARM-OMK.

Этап 2: каркас и БД.
Этап 3: аутентификация, роли, управление пользователями.
Этап 4: страницы справочника.
Этап 6: подготовка к работе на сервере (vendor-библиотеки, журнал в файл,
        WAL, обработчик 500).
"""
import logging
import os
import sqlite3
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path

# --- vendor ---------------------------------------------------------------
# Библиотеки лежат внутри проекта (vendor/), чтобы на сервере не требовался
# `pip install`. Путь добавляется ДО импорта flask и остальных пакетов.
_VENDOR_DIR = Path(__file__).resolve().parent.parent / "vendor"
if _VENDOR_DIR.is_dir() and str(_VENDOR_DIR) not in sys.path:
    sys.path.insert(0, str(_VENDOR_DIR))

from flask import Flask, g, jsonify, redirect, render_template, request, send_from_directory, url_for  # noqa: E402

from . import (  # noqa: E402
    account,
    audit,
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
from .config import BASE_DIR, Config  # noqa: E402


def _setup_logging(app: Flask) -> None:
    """Журнал приложения в файл с ротацией (служба работает без консоли)."""
    log_dir = Path(app.config["LOG_DIR"])
    log_dir.mkdir(parents=True, exist_ok=True)
    handler = RotatingFileHandler(
        log_dir / "app.log",
        maxBytes=1_000_000,
        backupCount=5,
        encoding="utf-8",
    )
    handler.setFormatter(
        logging.Formatter("%(asctime)s %(levelname)s [%(name)s] %(message)s")
    )
    app.logger.addHandler(handler)
    app.logger.setLevel(logging.INFO)


def _init_database(app: Flask) -> None:
    """Включить WAL и таймаут блокировок (важно при 2–3 одновременных users).

    journal_mode=WAL сохраняется в самом файле БД, поэтому достаточно
    выполнить один раз при старте.
    """
    database = app.config["DATABASE"]
    if not os.path.exists(database):
        app.logger.warning("Файл БД не найден: %s", database)
        return
    try:
        conn = sqlite3.connect(database, timeout=5)
        try:
            mode = conn.execute("PRAGMA journal_mode = WAL").fetchone()[0]
            conn.execute("PRAGMA busy_timeout = 5000")
        finally:
            conn.close()
        app.logger.info("БД: %s, journal_mode=%s", database, mode)
    except sqlite3.Error as exc:
        app.logger.error("Не удалось включить WAL: %s", exc)


def create_app(config_object=Config) -> Flask:
    app = Flask(__name__)
    app.config.from_object(config_object)

    _setup_logging(app)
    os.makedirs(os.path.dirname(app.config["DATABASE"]), exist_ok=True)
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)
    _init_database(app)

    db.init_app(app)
    security.init_app(app)
    audit.init_app(app)

    app.register_blueprint(auth.bp)
    app.register_blueprint(account.bp)
    app.register_blueprint(audit.bp)
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
        """Самопроверка: приложение живо и БД отвечает.

        Наружу отдаётся только статус: путь к файлу БД и количество строк —
        лишняя информация для страницы без авторизации.
        """
        try:
            db.get_db().execute("SELECT 1").fetchone()
        except sqlite3.Error:
            app.logger.exception("Проверка /health: БД недоступна")
            return jsonify(status="error"), 500
        return jsonify(status="ok")

    @app.after_request
    def security_headers(response):
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "SAMEORIGIN")
        response.headers.setdefault("Referrer-Policy", "same-origin")
        return response

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

    @app.errorhandler(500)
    def internal_error(exc):
        app.logger.exception("Необработанная ошибка на %s", request.path)
        return render_template("error.html", code=500,
                               message="Внутренняя ошибка сервера. "
                                       "Подробности записаны в журнал."), 500

    return app
