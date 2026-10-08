#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR/server"
SERVER_URL="https://api.purpurmc.org/v2/purpur/1.17.1/1428/download"

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This installer requires apt-get (Debian or Ubuntu)." >&2
    exit 1
fi

sudo_cmd=()
if (( EUID != 0 )); then
    if ! command -v sudo >/dev/null 2>&1; then
        echo "Run as root or install sudo to install Java 17." >&2
        exit 1
    fi
    sudo_cmd=(sudo)
fi

"${sudo_cmd[@]}" apt-get update
"${sudo_cmd[@]}" apt-get install -y openjdk-17-jre-headless wget

if ! command -v java >/dev/null 2>&1; then
    echo "Java was not found after installation." >&2
    exit 1
fi

if [[ ! -s "$SERVER_DIR/server.jar" ]]; then
    download_tmp="$(mktemp "$SERVER_DIR/server.jar.XXXXXX")"
    trap 'rm -f -- "$download_tmp"' EXIT
    if ! wget -q -O "$download_tmp" "$SERVER_URL"; then
        echo "Could not download the Purpur server jar." >&2
        exit 1
    fi
    if [[ ! -s "$download_tmp" ]]; then
        echo "The Purpur download was empty; server.jar was not replaced." >&2
        exit 1
    fi
    mv -- "$download_tmp" "$SERVER_DIR/server.jar"
fi

echo "Setup complete. Start the game server with ./paper.sh."
