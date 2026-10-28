#!/usr/bin/env bash
# ARM-OMK — запуск сайта вручную (аналог start_server.bat).
#
#   ./linux/start_server.sh               # порт из .env (по умолчанию 80)
#   PORT=5000 ./linux/start_server.sh     # разовый запуск на другом порту
#
# Порт 80 без root-прав недоступен — для пробы запускайте на 5000,
# для постоянной работы ставьте службу: sudo ./linux/install_service.sh
#
# Остановка — Ctrl+C.

set -euo pipefail

# Каталог проекта: ищем serve.py рядом со скриптом или выше
# (в комплекте это <проект>/linux/, в репозитории — <проект>/deploy/linux/).
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for _ in 1 2 3; do
    [[ -f "$ROOT/serve.py" ]] && break
    ROOT="$(dirname "$ROOT")"
done

if [[ ! -f "$ROOT/serve.py" ]]; then
    echo "ОШИБКА: не найден serve.py (искал в $ROOT и выше)." >&2
    exit 1
fi
if [[ ! -d "$ROOT/vendor" ]]; then
    echo "ОШИБКА: не найдена папка vendor/ — скопируйте комплект целиком." >&2
    exit 1
fi

cd "$ROOT"

PYTHON="${PYTHON:-python3}"
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    echo "ОШИБКА: не найден $PYTHON." >&2
    echo "Установите Python 3.9+ (пакет python3), например:" >&2
    echo "  Debian/Ubuntu/Astra: sudo apt install python3" >&2
    exit 1
fi

echo "Python: $("$PYTHON" --version 2>&1)"
echo "Проект: $ROOT"
exec "$PYTHON" serve.py
