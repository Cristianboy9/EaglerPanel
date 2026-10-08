#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR/server"
PAPER_MEMORY="${PAPER_MEMORY:-8192M}"

if ! command -v java >/dev/null 2>&1; then
    echo "Java is required. Run ./install.sh first." >&2
    exit 1
fi
if [[ ! -s "$SERVER_DIR/server.jar" ]]; then
    echo "server/server.jar is missing. Run ./install.sh first." >&2
    exit 1
fi

cd -- "$SERVER_DIR"
exec java "-Xms$PAPER_MEMORY" "-Xmx$PAPER_MEMORY" -jar server.jar
