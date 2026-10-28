#!/usr/bin/env bash
# Ежедневная резервная копия базы через systemd-таймер.
#
#   sudo ./linux/install_backup_timer.sh
#
# Ставит два юнита (arm-omk-backup.service и .timer), включает таймер
# на 03:00 и сразу делает одну копию для проверки.
# Копии: _backup/db/ (хранятся последние 30, см. KEEP в backup_db.sh).

set -euo pipefail

die() { echo "ОШИБКА: $*" >&2; exit 1; }

[[ ${EUID} -eq 0 ]] || die "запускать нужно от root: sudo $0"
command -v systemctl >/dev/null 2>&1 || die "в системе нет systemd"

LINUXDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$LINUXDIR"
for _ in 1 2 3; do
    [[ -f "$ROOT/serve.py" ]] && break
    ROOT="$(dirname "$ROOT")"
done
[[ -f "$ROOT/serve.py" ]] || die "не найден serve.py (искал в $LINUXDIR и выше)"

PYTHON="${PYTHON:-$(command -v python3 || true)}"
[[ -n "$PYTHON" ]] || die "не найден python3"

# Пользователя берём из уже установленной службы, иначе — arm-omk.
SERVICE_USER="$(sed -n 's/^User=//p' /etc/systemd/system/arm-omk.service 2>/dev/null | head -n 1)"
SERVICE_USER="${SERVICE_USER:-arm-omk}"
id -u "$SERVICE_USER" >/dev/null 2>&1 \
    || die "нет пользователя $SERVICE_USER — сначала: sudo $LINUXDIR/install_service.sh"

mkdir -p "$ROOT/_backup" "$ROOT/logs"
chown -R "$SERVICE_USER:$SERVICE_USER" "$ROOT/_backup" "$ROOT/logs"

for unit in arm-omk-backup.service arm-omk-backup.timer; do
    src="$LINUXDIR/$unit"
    [[ -f "$src" ]] || die "нет шаблона $src"
    sed -e "s|@ROOT@|$ROOT|g" \
        -e "s|@USER@|$SERVICE_USER|g" \
        -e "s|@PYTHON@|$PYTHON|g" \
        -e "s|@LINUXDIR@|$LINUXDIR|g" \
        "$src" > "/etc/systemd/system/$unit"
    chmod 644 "/etc/systemd/system/$unit"
    echo "Установлен /etc/systemd/system/$unit"
done

systemctl daemon-reload
systemctl enable --now arm-omk-backup.timer

echo
echo "Таймер включён. Проверка (запускаю копию прямо сейчас):"
systemctl start arm-omk-backup.service
sleep 2
systemctl status arm-omk-backup.service --no-pager -n 5 || true

echo
echo "Расписание: systemctl list-timers arm-omk-backup.timer --no-pager"
echo "Журнал:     journalctl -u arm-omk-backup -n 20"
echo "Копии:      $ROOT/_backup/db/"
