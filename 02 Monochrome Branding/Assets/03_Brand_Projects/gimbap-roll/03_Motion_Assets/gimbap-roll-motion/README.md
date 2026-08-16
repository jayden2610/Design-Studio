# Gimbap Roll Motion

Open `demo.html` through a local HTTP server and scroll through the four semantic states.

## Current build

- `source/keyframes/K0.png` through `K3.png` are the verified chroma keyframes.
- `demo.html` is the working scroll-controlled prototype. It loads pre-keyed transparent frames and falls back to the final frame for reduced motion, so it also works when opened directly from `file://`.
- `motion-brief.md` and the three adjacent-frame prompt files are ready for continuous Oil Motion video generation.
- `final/keyframes/` contains the handoff copies used by the demo and future compile.
- `tools/ffmpeg/bin/` contains a project-local FFmpeg 9.0 essentials build; use `tools/run_oil_motion.py` so the bundled Python runtime can see it.

## Finish the continuous render

The workspace still has no ZenMux API key, so the MiniMax H3 render is not used. FFmpeg is configured locally. Choose a video provider, generate K0→K1, K1→K2, and K2→K3 from the prompt files, concatenate the raw clips, and run `python tools/run_oil_motion.py compile_scroll_video.py` with `build/gimbap-budget-random.json`.

The prototype is deliberately discrete between semantic keyframes; it does not pretend that a still-image crossfade is the final motion render.
