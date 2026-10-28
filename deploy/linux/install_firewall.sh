#!/usr/bin/env bash
# Открыть порт сайта в брандмауэре (аналог install_firewall.bat).
#
#   sudo ./linux/install_firewall.sh
#
# Поддерживаются ufw (Debian/Ubuntu/Astra) и firewalld (RHEL/Alma/Rocky).
# Порт берётся из .env (по умолчанию 80).

set -euo pipefail

die() { echo "ОШИБКА: $*" >&2; exit 1; }

[[ ${EUID} -eq 0 ]] || die "запускать нужно от root: sudo $0"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for _ in 1 2 3; do
    [[ -f "$ROOT/serve.py" ]] && break
    ROOT="$(dirname "$ROOT")"
done

PORT=80
if [[ -f "$ROOT/.env" ]]; then
    PORT="$(sed -n 's/^PORT=\([0-9]*\).*/\1/p' "$ROOT/.env" | tail -n 1)"
    PORT="${PORT:-80}"
fi

echo "Открываю TCP-порт $PORT"

if command -v ufw >/dev/null 2>&1; then
    ufw allow "$PORT/tcp"
    echo
    ufw status | sed -n '1,12p'
    echo
    echo "Если ufw ещё не включали: sudo ufw enable"
elif command -v firewall-cmd >/dev/null 2>&1; then
    if [[ "$PORT" == "80" ]]; then
        firewall-cmd --permanent --add-service=http
    else
        firewall-cmd --permanent --add-port="$PORT/tcp"
    fi
    firewall-cmd --reload
    echo
    firewall-cmd --list-all | sed -n '1,12p'
else
    echo "ufw и firewalld не найдены."
    echo "Откройте порт средствами вашей системы, например:"
    echo "  nft add rule inet filter input tcp dport $PORT accept"
    echo "  iptables -A INPUT -p tcp --dport $PORT -j ACCEPT"
fi

IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
SUFFIX=""
[[ "$PORT" != "80" ]] && SUFFIX=":$PORT"
[[ -n "$IP" ]] && echo "Проверка с другого ПК: http://${IP}${SUFFIX}/"
