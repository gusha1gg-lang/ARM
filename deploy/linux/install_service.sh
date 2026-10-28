#!/usr/bin/env bash
# Установка ARM-OMK как службы systemd (аналог install_autostart.bat).
#
#   sudo ./linux/install_service.sh
#
# Что делает:
#   1) создаёт системного пользователя arm-omk (если его нет);
#   2) выдаёт ему права на запись в instance/, uploads/, logs/, _backup/;
#   3) подставляет реальные пути в arm-omk.service и кладёт его в /etc/systemd/system/;
#   4) включает автозапуск при загрузке и запускает сайт.
#
# Порт 80 служба получает через CAP_NET_BIND_SERVICE — root-права ей не нужны.
# Удаление: sudo ./linux/uninstall_service.sh

set -euo pipefail

die() { echo "ОШИБКА: $*" >&2; exit 1; }

[[ ${EUID} -eq 0 ]] || die "запускать нужно от root: sudo $0"

LINUXDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$LINUXDIR"
for _ in 1 2 3; do
    [[ -f "$ROOT/serve.py" ]] && break
    ROOT="$(dirname "$ROOT")"
done
[[ -f "$ROOT/serve.py" ]] || die "не найден serve.py (искал в $LINUXDIR и выше)"
[[ -d "$ROOT/vendor" ]] || die "не найдена папка vendor/"

command -v systemctl >/dev/null 2>&1 || die "в системе нет systemd"

SERVICE=arm-omk
SERVICE_USER="${SERVICE_USER:-arm-omk}"
PYTHON="${PYTHON:-$(command -v python3 || true)}"
[[ -n "$PYTHON" ]] || die "не найден python3 (установите пакет python3)"
"$PYTHON" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' \
    || die "нужен Python 3.9 или новее, найден: $("$PYTHON" --version 2>&1)"

echo "Проект:  $ROOT"
echo "Python:  $PYTHON ($("$PYTHON" --version 2>&1))"
echo "Служба:  $SERVICE, пользователь: $SERVICE_USER"
echo

# --- 1. системный пользователь -------------------------------------------
if id -u "$SERVICE_USER" >/dev/null 2>&1; then
    echo "Пользователь $SERVICE_USER уже есть"
else
    NOLOGIN="$(command -v nologin || echo /bin/false)"
    useradd --system --home-dir "$ROOT" --shell "$NOLOGIN" "$SERVICE_USER"
    echo "Создан пользователь $SERVICE_USER"
fi

# --- 2. права на запись ---------------------------------------------------
# Код и vendor остаются у root, служба их только читает.
# Папки, куда пишет приложение (база, картинки, журналы, копии), — её.
for dir in instance uploads logs _backup; do
    mkdir -p "$ROOT/$dir"
    chown -R "$SERVICE_USER:$SERVICE_USER" "$ROOT/$dir"
done
# serve.py при первом запуске создаёт .env в корне проекта — даём группе право
# создавать файлы в корне (но не менять существующий код).
chgrp "$SERVICE_USER" "$ROOT"
chmod g+w "$ROOT"

if [[ -f "$ROOT/.env" ]]; then
    chgrp "$SERVICE_USER" "$ROOT/.env"
    chmod g+r "$ROOT/.env"
    echo "Файл .env есть — SECRET_KEY сохраняется"
else
    echo "Файла .env нет — serve.py создаст его при первом запуске"
fi

# --- 2a. проверка, что служба сможет войти в каталог ----------------------
# Частая ошибка: комплект распакован в /root или в домашний каталог с правами
# 750 — служба получает "Changing to the requested working directory failed".
as_user() {
    if command -v runuser >/dev/null 2>&1; then
        runuser -u "$SERVICE_USER" -- "$@"
    else
        su -s /bin/sh -c "$(printf '%q ' "$@")" "$SERVICE_USER"
    fi
}

if ! as_user test -x "$ROOT" 2>/dev/null; then
    die "пользователь $SERVICE_USER не может открыть каталог $ROOT.
  Скорее всего, проект лежит в /root или в домашнем каталоге с правами 750.
  Перенесите его в /opt и запустите установку оттуда:
    sudo mv \"$ROOT\" /opt/arm-omk
    cd /opt/arm-omk && sudo ./linux/install_service.sh"
fi
as_user test -r "$ROOT/serve.py" \
    || die "пользователь $SERVICE_USER не может прочитать $ROOT/serve.py (проверьте права на файлы)"
as_user test -w "$ROOT" \
    || die "пользователь $SERVICE_USER не может создать .env в $ROOT"
as_user test -w "$ROOT/logs" \
    || die "нет прав на запись в $ROOT/logs"
as_user test -r "$ROOT/instance/asutp.db" \
    || die "нет доступа к базе $ROOT/instance/asutp.db"
echo "Права проверены: $SERVICE_USER может читать код и писать в instance/, uploads/, logs/, _backup/"

# --- 3. unit-файл ---------------------------------------------------------
UNIT_SRC="$LINUXDIR/arm-omk.service"
[[ -f "$UNIT_SRC" ]] || die "нет шаблона $UNIT_SRC"
UNIT_DST="/etc/systemd/system/$SERVICE.service"

sed -e "s|@ROOT@|$ROOT|g" \
    -e "s|@USER@|$SERVICE_USER|g" \
    -e "s|@PYTHON@|$PYTHON|g" \
    "$UNIT_SRC" > "$UNIT_DST"
chmod 644 "$UNIT_DST"
echo "Установлен $UNIT_DST"

# --- 4. запуск ------------------------------------------------------------
systemctl daemon-reload
systemctl enable --now "$SERVICE"

sleep 3
if ! systemctl is-active --quiet "$SERVICE"; then
    echo
    echo "СЛУЖБА НЕ ЗАПУСТИЛАСЬ. Последние строки журнала:"
    journalctl -u "$SERVICE" -n 20 --no-pager || true
    echo
    echo "Частые причины:"
    echo "  * порт 80 занят (nginx/apache) — оставьте nginx на 80,"
    echo "    в .env поставьте PORT=5000 и HOST=127.0.0.1, см. linux/nginx-arm-omk.conf.example;"
    echo "  * нет прав на папки — перезапустите этот скрипт;"
    echo "  * не найден python3 — укажите путь: sudo PYTHON=/usr/bin/python3.12 $0"
    exit 1
fi

IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
PORT="$(sed -n 's/^PORT=\([0-9]*\).*/\1/p' "$ROOT/.env" 2>/dev/null | tail -n 1)"
PORT="${PORT:-80}"
SUFFIX=""
[[ "$PORT" != "80" ]] && SUFFIX=":$PORT"

echo
echo "Готово. Служба работает и включена в автозапуск."
echo "  проверка:   systemctl status $SERVICE --no-pager"
echo "  журнал:     journalctl -u $SERVICE -f"
echo "  перезапуск: systemctl restart $SERVICE"
echo "  остановка:  systemctl stop $SERVICE"
echo
echo "  сайт:       http://127.0.0.1${SUFFIX}/"
[[ -n "$IP" ]] && echo "  из сети:    http://${IP}${SUFFIX}/"
echo
echo "Осталось (по желанию):"
echo "  sudo $LINUXDIR/install_firewall.sh        # доступ с других ПК"
echo "  sudo $LINUXDIR/install_backup_timer.sh    # ежедневная резервная копия"
echo "  Не забудьте сменить пароль admin в шапке сайта: «Сменить пароль»."
