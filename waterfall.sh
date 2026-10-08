#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WATERFALL_DIR="$SCRIPT_DIR/waterfall"
WATERFALL_MEMORY="${WATERFALL_MEMORY:-4096M}"
WATERFALL_URL="https://fill-data.papermc.io/v1/objects/c01e869894a0e1a6708c342caadbeaa167d99759a8fab0ed34ac6c26c51383dd/waterfall-1.20-562.jar"

if ! command -v java >/dev/null 2>&1; then
    echo "Java is required. Run ./install.sh first." >&2
    exit 1
fi

if [[ ! -s "$WATERFALL_DIR/waterfall.jar" ]]; then
    download_tmp="$(mktemp "$WATERFALL_DIR/waterfall.jar.XXXXXX")"
    trap 'rm -f -- "$download_tmp"' EXIT
    if ! wget -q -O "$download_tmp" "$WATERFALL_URL"; then
        echo "Could not download the Waterfall proxy jar." >&2
        exit 1
    fi
    if [[ ! -s "$download_tmp" ]]; then
        echo "The Waterfall download was empty; waterfall.jar was not replaced." >&2
        exit 1
    fi
    mv -- "$download_tmp" "$WATERFALL_DIR/waterfall.jar"
fi

cd -- "$WATERFALL_DIR"
trap 'exit 130' INT
trap 'exit 143' TERM

while true; do
    if java "-Xms$WATERFALL_MEMORY" "-Xmx$WATERFALL_MEMORY" -XX:+UseG1GC -XX:G1HeapRegionSize=4M \
        -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled \
        -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar waterfall.jar --nogui; then
        exit 0
    else
        status=$?
    fi

    echo "Waterfall exited with status $status; restarting in 5 seconds..." >&2
    sleep 5
done
