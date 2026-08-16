# 02 — Gimbap roll motion brief

## Direction

An editorial black-ink gimbap illustration progresses through four semantic states as the viewer scrolls:

1. K0 — open nori, rice, and filling are ready on the bamboo mat.
2. K1 — the first fold wraps over the filling.
3. K2 — the roll is nearly closed and being tightened.
4. K3 — the completed gimbap roll is pressed into its final form.

## Motion contract

- Fixed camera, fixed bamboo mat, fixed hand identity, fixed black-and-white ink treatment.
- Only the roll state changes between adjacent keyframes.
- Flat chroma background: `#00FF00`.
- Page background owns the visible final color; the green field is never shown to the user.
- Linear scroll mapping; no autoplay and no continuous-playback simulation.
- Reduced motion resolves to the final completed-roll poster.

## Delivery

The project contains a verified four-keyframe prototype and a production-ready handoff structure for the Oil Motion chroma-video path. Continuous video generation is pending a configured ZenMux/MiniMax API key.
