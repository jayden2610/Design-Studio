from __future__ import annotations

import os
import runpy
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FFMPEG_BIN = ROOT / "tools" / "ffmpeg" / "bin"
SCRIPT_DIR = ROOT.parent / "oil-motion" / "scripts"


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit("Usage: python tools/run_oil_motion.py <script.py> [args...]")
    script = (SCRIPT_DIR / sys.argv[1]).resolve()
    if script.parent != SCRIPT_DIR or script.suffix != ".py" or not script.is_file():
        raise SystemExit(f"Oil Motion script not found: {script}")
    os.environ["PATH"] = str(FFMPEG_BIN) + os.pathsep + os.environ.get("PATH", "")
    sys.path.insert(0, str(SCRIPT_DIR))
    sys.argv = [str(script), *sys.argv[2:]]
    runpy.run_path(str(script), run_name="__main__")


if __name__ == "__main__":
    main()
