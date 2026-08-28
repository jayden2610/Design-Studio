#!/usr/bin/env python3
"""Record reel.html playback as a 1080×1920 Instagram MP4.

Captures the designed CSS rise / wipe / zoom on every beat, then trims
to the five-beat 10s timeline. Requires Playwright + a Chrome/Chromium.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

try:
    import numpy as np
    from PIL import Image
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "pillow", "numpy"])
    import numpy as np
    from PIL import Image

from playwright.sync_api import sync_playwright

BEATS = (
    ("01-mark", 2.8),
    ("02-colour", 1.5),
    ("03-type", 1.6),
    ("04-pattern", 1.8),
    ("05-packaging", 2.3),
)
TOTAL_S = sum(duration for _, duration in BEATS)


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, check=True, **kwargs)


def ffprobe_duration(path: Path) -> float:
    out = subprocess.run(
        [
            "ffprobe",
            "-v",
            "error",
            "-show_entries",
            "format=duration",
            "-of",
            "default=nk=1:nw=1",
            str(path),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return float(out.stdout.strip())


def encode_master(src: Path, dest: Path, start: float, duration: float) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    run(
        [
            "ffmpeg",
            "-y",
            "-ss",
            f"{start:.3f}",
            "-i",
            str(src),
            "-t",
            f"{duration:.3f}",
            "-f",
            "lavfi",
            "-t",
            f"{duration:.3f}",
            "-i",
            "anullsrc=channel_layout=stereo:sample_rate=44100",
            "-map",
            "0:v:0",
            "-map",
            "1:a:0",
            "-vf",
            "scale=1080:1920:flags=lanczos,setsar=1,fps=30,format=yuv420p",
            "-c:v",
            "libx264",
            "-preset",
            "slow",
            "-crf",
            "18",
            "-pix_fmt",
            "yuv420p",
            "-c:a",
            "aac",
            "-b:a",
            "128k",
            "-shortest",
            "-movflags",
            "+faststart",
            str(dest),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )


def top_luma_series(video: Path, dest: Path, fps: int = 10) -> list[float]:
    """Mean luma of the top 90px, one sample per 1/fps second."""
    dest.mkdir(parents=True, exist_ok=True)
    for old in dest.glob("*.png"):
        old.unlink()
    run(
        [
            "ffmpeg",
            "-y",
            "-i",
            str(video),
            "-vf",
            f"fps={fps},crop=1080:90:0:0,scale=108:9",
            str(dest / "%04d.png"),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )
    values: list[float] = []
    for path in sorted(dest.glob("*.png")):
        arr = np.asarray(Image.open(path).convert("L"), dtype=np.float32)
        values.append(float(arr.mean()))
    return values


def detect_play_start(raw: Path, work: Path) -> float:
    """Colour beat is a full-width INK band. Find that cut, then rewind 2.8s."""
    samples = top_luma_series(raw, work / "luma", fps=10)
    if not samples:
        return 0.0
    ink_idx = None
    for i, luma in enumerate(samples):
        if luma < 55:
            # Confirm it holds — not a single dark illustration pixel.
            window = samples[i : i + 4]
            if len(window) >= 3 and sum(v < 70 for v in window) >= 3:
                ink_idx = i
                break
    if ink_idx is None:
        print("warning: colour-beat cut not found; using t=0", file=sys.stderr)
        return 0.0
    colour_t = ink_idx / 10.0
    start = max(0.0, colour_t - BEATS[0][1])
    print(f"colour cut at {colour_t:.2f}s → play start {start:.2f}s")
    return start


def record_playback(url: str, raw_webm: Path) -> None:
    raw_webm.parent.mkdir(parents=True, exist_ok=True)
    with sync_playwright() as p:
        browser = p.chromium.launch(
            channel="chrome",
            headless=True,
            args=[
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--hide-scrollbars",
                "--window-size=1080,1920",
            ],
        )
        context = browser.new_context(
            viewport={"width": 1080, "height": 1920},
            device_scale_factor=1,
            record_video_dir=str(raw_webm.parent),
            record_video_size={"width": 1080, "height": 1920},
        )
        page = context.new_page()
        page.emulate_media(reduced_motion="no-preference")
        page.goto(url, wait_until="networkidle", timeout=60000)
        page.evaluate(
            """async () => {
              await document.fonts.ready;
              await Promise.all(
                [...document.images].map((img) => img.decode().catch(() => {}))
              );
            }"""
        )
        page.wait_for_timeout(250)
        page.keyboard.press("Space")
        page.wait_for_timeout(int(TOTAL_S * 1000) + 400)
        recorded = Path(page.video.path())
        context.close()
        browser.close()
        if recorded.resolve() != raw_webm.resolve():
            recorded.replace(raw_webm)


def match_beats(master: Path, stills: Path) -> None:
    names = [name for name, _ in BEATS]
    sources = {}
    for name in names:
        still = stills / f"{name}.png"
        if not still.exists():
            print(f"skip beat match; missing {still}", file=sys.stderr)
            return
        sources[name] = np.asarray(Image.open(still).convert("RGB").resize((270, 480)))

    t = 0.0
    check_dir = master.parent / "beat-check"
    check_dir.mkdir(exist_ok=True)
    ok = True
    for name, duration in BEATS:
        mid = t + duration * 0.55
        frame = check_dir / f"{name}.png"
        run(
            [
                "ffmpeg",
                "-y",
                "-ss",
                f"{mid:.3f}",
                "-i",
                str(master),
                "-frames:v",
                "1",
                "-vf",
                "scale=270:480",
                str(frame),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
        )
        arr = np.asarray(Image.open(frame).convert("RGB"))
        scores = {
            other: float(np.mean((arr.astype(np.float32) - sources[other].astype(np.float32)) ** 2))
            for other in names
        }
        best = min(scores, key=scores.get)
        mark = "ok" if best == name else "MISMATCH"
        if best != name:
            ok = False
        print(f"  {name:14} t={mid:5.2f}s  best={best:12}  mse={scores[name]:8.1f}  {mark}")
        t += duration
    if not ok:
        raise SystemExit("reel beat sequence did not match the five stills")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default="http://127.0.0.1:8765/social/reel.html?export=1&hold=1")
    parser.add_argument("--work", type=Path, default=Path("/tmp/gimbap-reel"))
    parser.add_argument("--stills", type=Path, default=None)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    work = args.work
    work.mkdir(parents=True, exist_ok=True)
    raw = work / "playback.webm"
    print(f"recording {args.url}")
    record_playback(args.url, raw)
    print(f"raw {raw} ({ffprobe_duration(raw):.2f}s)")
    start = detect_play_start(raw, work)
    encode_master(raw, args.out, start, TOTAL_S)
    print(f"wrote {args.out} ({ffprobe_duration(args.out):.2f}s)")
    if args.stills:
        print("matching beats to stills")
        match_beats(args.out, args.stills)


if __name__ == "__main__":
    main()
