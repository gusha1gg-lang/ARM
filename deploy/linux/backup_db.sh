#!/usr/bin/env bash
# Резервная копия базы ARM-OMK (аналог tools/backup_db.bat).
#
#   ./linux/backup_db.sh                 # только база, хранить 30 копий
#   ./linux/backup_db.sh --with-files    # ещё uploads/ и Slegenie/
#   KEEP=60 ./linux/backup_db.sh         # хранить 60 копий
#
# Копии складываются в _backup/db/. Скрипт безопасен при работающем сайте:
# база копируется через SQLite backup API (учитывает журнал WAL).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for _ in 1 2 3; do
    [[ -f "$ROOT/serve.py" ]] && break
    ROOT="$(dirname "$ROOT")"
done

cd "$ROOT"

PYTHON="${PYTHON:-python3}"
KEEP="${KEEP:-30}"
LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR"

{
    echo "=== $(date '+%Y-%m-%d %H:%M:%S') резервная копия ==="
    "$PYTHON" tools/backup_db.py --keep "$KEEP" "$@"
} >> "$LOG_DIR/backup.log" 2>&1

tail -n 3 "$LOG_DIR/backup.log"
