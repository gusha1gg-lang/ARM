"""Рабочий (серверный) запуск: python serve.py

Отличия от run.py:
  * используется waitress — рабочий WSGI-сервер для Windows, а не отладочный
    сервер Flask;
  * DEBUG принудительно выключен;
  * если SECRET_KEY не задан (или остался значением-заглушкой), он
    генерируется и записывается в .env — иначе cookie сессии можно подделать;
  * по умолчанию сайт слушает все интерфейсы (0.0.0.0), чтобы был доступен
    из локальной сети.

    Остановка — Ctrl+C.
"""
from __future__ import annotations

import os
import secrets
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

# --- пути ----------------------------------------------------------------
# Папку проекта добавляем явно: в «урезанном» Python (embeddable, флаг
# -P / PYTHONSAFEPATH) каталог скрипта в sys.path не попадает.
if str(BASE_DIR) not in sys.path:
    sys.path.insert(0, str(BASE_DIR))

# --- vendor ---------------------------------------------------------------
VENDOR_DIR = BASE_DIR / "vendor"
if VENDOR_DIR.is_dir() and str(VENDOR_DIR) not in sys.path:
    sys.path.insert(0, str(VENDOR_DIR))

ENV_FILE = BASE_DIR / ".env"
INSECURE_KEYS = {"", "dev-only-insecure-key", "change-me-to-random-string"}

ENV_TEMPLATE = """# Настройки ARM-OMK. Файл создан автоматически при первом запуске serve.py.
# .env не коммитится в git.

# Секретный ключ сессий (сгенерирован случайно).
SECRET_KEY={secret}

# Путь к файлу SQLite (относительно корня проекта)
DATABASE_PATH=instance/asutp.db

# Папка для загружаемых изображений камер (относительно корня проекта)
UPLOAD_FOLDER=uploads

# Адрес и порт. 0.0.0.0 — доступ из локальной сети.
# PORT=80 — сайт открывается без порта: http://<IP-компьютера>/
# Если порт 80 занят другой программой, поставьте PORT=5000 и добавьте
# порт в адрес: http://<IP-компьютера>:5000/
HOST=0.0.0.0
PORT=80

# Отладка. На сервере всегда 0.
DEBUG=0
"""


def _read_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def _write_env_var(path: Path, key: str, value: str) -> None:
    """Записать/заменить переменную в .env, сохранив остальные строки."""
    if not path.exists():
        path.write_text(ENV_TEMPLATE.format(secret=value), encoding="utf-8")
        return

    lines = path.read_text(encoding="utf-8").splitlines()
    for index, raw in enumerate(lines):
        stripped = raw.strip()
        if stripped.startswith("#") or "=" not in stripped:
            continue
        if stripped.split("=", 1)[0].strip() == key:
            lines[index] = f"{key}={value}"
            break
    else:
        lines.append(f"{key}={value}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _ensure_secret_key() -> str:
    """Вернуть рабочий SECRET_KEY, при необходимости создав его."""
    current = os.environ.get("SECRET_KEY") or _read_env_file(ENV_FILE).get(
        "SECRET_KEY", ""
    )
    if current in INSECURE_KEYS:
        current = secrets.token_hex(32)
        _write_env_var(ENV_FILE, "SECRET_KEY", current)
        print("Сгенерирован новый SECRET_KEY и записан в .env")
    os.environ["SECRET_KEY"] = current
    return current


def _primary_ipv4() -> str:
    """Основной IPv4-адрес в локальной сети (пакеты при этом не отправляются)."""
    import socket

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.connect(("10.255.255.255", 1))
        return sock.getsockname()[0]
    except OSError:
        return ""
    finally:
        sock.close()


def _local_ipv4() -> list[str]:
    """IPv4-адреса этого компьютера без петлевых и служебных (169.254.*)."""
    import socket

    result: list[str] = []
    try:
        infos = socket.getaddrinfo(socket.gethostname(), None, socket.AF_INET)
    except OSError:
        return result
    for info in infos:
        ip = info[4][0]
        if ip.startswith("127.") or ip.startswith("169.254."):
            continue
        if ip not in result:
            result.append(ip)
    return result


def _port_is_free(host: str, port: int) -> bool:
    """Проверить, можно ли занять порт (Windows: порт 80 доступен без админа)."""
    import socket

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        try:
            sock.bind((host, port))
        except OSError:
            return False
    return True


def _report_busy_port(port: int) -> None:
    print()
    print(f"ОШИБКА: порт {port} уже занят другой программой.")
    print("  Кто занял порт (в командной строке от администратора):")
    print(f"    netstat -ano | findstr :{port}")
    print("    tasklist /FI \"PID eq <номер из последнего столбца>\"")
    print()
    print("  Что делать:")
    print("   1) остановить программу, занявшую порт (часто это IIS или другой")
    print("      веб-сервер), затем запустить start_server.bat снова;")
    print("   2) либо открыть файл .env в папке проекта (Блокнотом), заменить")
    print("      строку PORT=80 на PORT=5000 и запустить снова — сайт будет")
    print("      открываться по адресу http://<IP-компьютера>:5000/")
    print()


def main() -> int:
    if not VENDOR_DIR.is_dir():
        print("Не найден каталог vendor/ — библиотеки не укомплектованы.")
        return 1

    _ensure_secret_key()

    # На сервере отладчик Werkzeug недопустим.
    os.environ["DEBUG"] = "0"

    from waitress import serve  # noqa: E402  (после настройки vendor)

    from app import create_app  # noqa: E402
    from app.config import Config  # noqa: E402

    host = os.environ.get("HOST") or "0.0.0.0"
    port = Config.PORT

    application = create_app()
    application.config["DEBUG"] = False

    suffix = "" if port == 80 else f":{port}"
    primary = _primary_ipv4()

    print()
    print("ARM-OMK — Справочник ТЭСК ТБД")
    print(f"  на этом компьютере:  http://127.0.0.1{suffix}/")
    if primary:
        print(f"  из локальной сети:   http://{primary}{suffix}/")
    else:
        for ip in _local_ipv4():
            print(f"  из локальной сети:   http://{ip}{suffix}/")
    if host == "127.0.0.1":
        print("  ВНИМАНИЕ: HOST=127.0.0.1 — доступ только с этого компьютера.")
        print("  Для доступа из сети укажите в .env HOST=0.0.0.0")
    print(f"  БД:     {application.config['DATABASE']}")
    print(f"  журнал: {Path(application.config['LOG_DIR']) / 'app.log'}")
    print("  остановка: Ctrl+C")
    print()

    if not _port_is_free(host, port):
        _report_busy_port(port)
        return 2

    serve(
        application,
        host=host,
        port=port,
        threads=8,
        ident="ARM-OMK",
        channel_timeout=120,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
