"""Конфигурация приложения.

Значения читаются из .env (см. .env.example). Если .env отсутствует,
используются безопасные значения по умолчанию для локального запуска.
"""
import os
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent
load_dotenv(BASE_DIR / ".env")


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-only-insecure-key")
    DATABASE = str(BASE_DIR / os.getenv("DATABASE_PATH", "instance/asutp.db"))
    UPLOAD_FOLDER = str(BASE_DIR / os.getenv("UPLOAD_FOLDER", "app/static/uploads"))
    MAX_CONTENT_LENGTH = 4 * 1024 * 1024  # 4 МБ, как в оригинале
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"
    HOST = os.getenv("HOST", "127.0.0.1")
    PORT = int(os.getenv("PORT", "5000"))
    DEBUG = os.getenv("DEBUG", "1") == "1"
