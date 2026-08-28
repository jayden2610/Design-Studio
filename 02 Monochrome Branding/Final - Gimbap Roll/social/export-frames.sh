#!/bin/bash
# Dump 01–05 as 1080×1920 stills for an Instagram Reel cover / optional carousel.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/social/export}"
PORT="${PORT:-8765}"
mkdir -p "$OUT"

if ! curl -sf "http://127.0.0.1:${PORT}/social/reel.html" >/dev/null; then
  python3 -m http.server "$PORT" --directory "$ROOT" >/tmp/gimbap-export-server.log 2>&1 &
  SERVER_PID=$!
  trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT
  sleep 0.4
fi

CHROME="${CHROME:-google-chrome-stable}"
names=(01-mark 02-colour 03-type 04-pattern 05-packaging)
for i in 0 1 2 3 4; do
  "$CHROME" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
    --window-size=1080,1920 --virtual-time-budget=3500 \
    --screenshot="${OUT}/${names[$i]}.png" \
    "http://127.0.0.1:${PORT}/social/reel.html?capture=1&hold=1&beat=${i}"
done
echo "Wrote 5 frames to ${OUT}"
