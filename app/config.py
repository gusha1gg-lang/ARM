"""Конфигурация приложения.

Значения читаются из .env (см. .env.example). Если .env отсутствует,
используются безопасные значения по умолчанию.
"""
import os
from datetime import timedelta
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")

#: Значение-заглушка из репозитория. С ним приложение можно запускать только
#: локально: зная ключ, можно подделать cookie сессии.
INSECURE_SECRET_KEY = "dev-only-insecure-key"


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", INSECURE_SECRET_KEY)
    DATABASE = str(BASE_DIR / os.getenv("DATABASE_PATH", "instance/asutp.db"))
    #: Каталог загрузок оригинального сайта. В БД уже лежат значения
    #: ``uploads/<файл>``, поэтому по умолчанию это ``uploads/`` в корне проекта.
    UPLOAD_FOLDER = str(BASE_DIR / os.getenv("UPLOAD_FOLDER", "uploads"))
    MAX_CONTENT_LENGTH = 4 * 1024 * 1024  # 4 МБ, как в оригинале

    # --- сессия ---------------------------------------------------------
    # Сессия живёт ровно сутки с момента входа, а не сутки бездействия:
    # SESSION_REFRESH_EACH_REQUEST=False запрещает продлевать срок на каждом
    # запросе. Дополнительно точное время входа хранится в session["login_at"]
    # и проверяется в security.load_logged_in_user().
    PERMANENT_SESSION_LIFETIME = timedelta(days=1)
    SESSION_REFRESH_EACH_REQUEST = False
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"

    # --- запуск ---------------------------------------------------------
    HOST = os.getenv("HOST", "127.0.0.1")
    PORT = int(os.getenv("PORT", "5000"))
    #: Отладка выключена по умолчанию: на сервере отладчик Werkzeug
    #: позволяет выполнить любой код через страницу ошибки.
    DEBUG = os.getenv("DEBUG", "0") == "1"

    #: Каталог журналов приложения (создаётся автоматически).
    LOG_DIR = str(BASE_DIR / os.getenv("LOG_DIR", "logs"))
