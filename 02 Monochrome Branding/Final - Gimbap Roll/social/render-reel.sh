#!/bin/bash
# Render the five-beat identity piece as a 1080×1920 Instagram Reel.
# Prefers a live capture of reel.html (CSS rise / wipe / zoom). Falls back
# to stills + a slow push-in on beat 01 if Playwright is not installed.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/social/export}"
PORT="${PORT:-8765}"
CHROME="${CHROME:-google-chrome-stable}"
mkdir -p "$OUT"

if ! curl -sf "http://127.0.0.1:${PORT}/social/reel.html" >/dev/null; then
  python3 -m http.server "$PORT" --directory "$ROOT" >/tmp/gimbap-export-server.log 2>&1 &
  SERVER_PID=$!
  trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT
  sleep 0.4
fi

names=(01-mark 02-colour 03-type 04-pattern 05-packaging)
for i in 0 1 2 3 4; do
  "$CHROME" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
    --window-size=1080,1920 --virtual-time-budget=4000 \
    --screenshot="${OUT}/${names[$i]}.png" \
    "http://127.0.0.1:${PORT}/social/reel.html?capture=1&hold=1&beat=${i}"
done

WORK="${WORK:-/tmp/gimbap-reel}"
mkdir -p "$WORK"
cp -f "${OUT}/01-mark.png" "${OUT}/cover.png"

record_live() {
  python3 "$ROOT/social/record-reel.py" \
    --url "http://127.0.0.1:${PORT}/social/reel.html?export=1&hold=1" \
    --work "$WORK" \
    --stills "$OUT" \
    --out "${OUT}/gimbap-roll-identity-reel.mp4"
}

concat_stills() {
  # 01 2.8s · 02 1.5s · 03 1.6s · 04 1.8s · 05 2.3s  →  10.0s
  # Loop each still at 30fps, then concat. Do not use zoompan's `d=` on a
  # looped input — it multiplies duration and -shortest keeps only beat 01.
  ffmpeg -y \
    -loop 1 -framerate 30 -t 2.8 -i "${OUT}/01-mark.png" \
    -loop 1 -framerate 30 -t 1.5 -i "${OUT}/02-colour.png" \
    -loop 1 -framerate 30 -t 1.6 -i "${OUT}/03-type.png" \
    -loop 1 -framerate 30 -t 1.8 -i "${OUT}/04-pattern.png" \
    -loop 1 -framerate 30 -t 2.3 -i "${OUT}/05-packaging.png" \
    -f lavfi -t 10 -i anullsrc=channel_layout=stereo:sample_rate=44100 \
    -filter_complex "\
      [0:v]scale=1166:2074:flags=lanczos,crop=1080:1920:'(in_w-1080)*n/83':'(in_h-1920)*n/83',setsar=1,fps=30,format=yuv420p[v0]; \
      [1:v]scale=1080:1920:flags=lanczos,setsar=1,fps=30,format=yuv420p[v1]; \
      [2:v]scale=1080:1920:flags=lanczos,setsar=1,fps=30,format=yuv420p[v2]; \
      [3:v]scale=1080:1920:flags=lanczos,setsar=1,fps=30,format=yuv420p[v3]; \
      [4:v]scale=1080:1920:flags=lanczos,setsar=1,fps=30,format=yuv420p[v4]; \
      [v0][v1][v2][v3][v4]concat=n=5:v=1:a=0[v]" \
    -map "[v]" -map 5:a \
    -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 128k \
    -t 10 \
    -movflags +faststart \
    "${OUT}/gimbap-roll-identity-reel.mp4"
}

if python3 -c "from playwright.sync_api import sync_playwright" 2>/dev/null; then
  echo "Recording live playback (CSS motion)…"
  record_live
else
  echo "Playwright not installed; concatenating stills."
  concat_stills
fi

echo "Wrote ${OUT}/gimbap-roll-identity-reel.mp4"
ffprobe -hide_banner "${OUT}/gimbap-roll-identity-reel.mp4"
