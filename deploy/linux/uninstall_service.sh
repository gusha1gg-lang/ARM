#!/usr/bin/env bash
# Удаление службы ARM-OMK (аналог remove_autostart.bat).
#
#   sudo ./linux/uninstall_service.sh
#
# Останавливает и убирает автозапуск. Данные НЕ удаляются:
# база, uploads/, logs/, _backup/ и .env остаются на месте.

set -euo pipefail

die() { echo "ОШИБКА: $*" >&2; exit 1; }

[[ ${EUID} -eq 0 ]] || die "запускать нужно от root: sudo $0"
command -v systemctl >/dev/null 2>&1 || die "в системе нет systemd"

SERVICE=arm-omk
UNIT="/etc/systemd/system/$SERVICE.service"

if [[ -f "$UNIT" ]]; then
    systemctl disable --now "$SERVICE" 2>/dev/null || true
    rm -f "$UNIT"
    systemctl daemon-reload
    systemctl reset-failed "$SERVICE" 2>/dev/null || true
    echo "Служба $SERVICE остановлена и удалена."
else
    echo "Службы $SERVICE нет — нечего удалять."
fi

echo
echo "Данные сохранены: instance/asutp.db, uploads/, logs/, _backup/, .env."
echo "Запустить вручную: ./linux/start_server.sh"
