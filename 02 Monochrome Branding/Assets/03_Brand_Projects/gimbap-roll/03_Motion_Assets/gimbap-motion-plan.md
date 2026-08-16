# Gimbap Roll — Oil Motion Plan

## Recommendation

Build one linear, scroll-controlled semantic action: the gimbap roll is formed from an open sheet and filling into the completed dark roll shown in the current study.

The animation should make the brand idea legible as a ritual — **roll, tighten, finish** — rather than act as a decorative loop.

## Motion brief

```yaml
subject: monochrome illustrated gimbap roll on a bamboo mat
reference: Assets/01_Approved_Illustrations/fnb-logo-01-gimbap-roll.png
driver: scroll
parameter_space: linear
motion: hand rolls the open gimbap assembly forward until the finished roll is held in place
meaning: progress from preparation to a finished food product
storyboard:
  - K0: open nori sheet, rice and filling aligned on the mat; hand ready at the near edge
  - K1: first fold covers the filling; the hand and mat remain locked in the same composition
  - K2: roll is nearly closed; the circular end begins to read clearly
  - K3: completed roll with the visible cut end and hand pressure matching the current study
rest_state: K3 completed roll
loop: none
background: chroma
key_color: '#00FF00'
background_owner: page
delivery: chroma-video
anchor: center
quality_target: sharp black ink at the real display size; no camera drift
interpolation_fps: 48
reduced_motion: static K3 poster
```

## Why this is the strongest direction

- It uses the existing mark's clearest evidence: one hero food object, one rolling gesture, and one bamboo-mat cue.
- Scroll is a natural metaphor for advancing the roll and gives a reversible, readable timeline.
- The action contains real semantic change — folding, occlusion, and tightening — so it is worth generating as motion rather than faking with CSS transforms.
- Pointer-following would add interaction without adding meaning; a 2D view grid would increase production cost without improving the core story.

## Visual constraints

- Preserve the current black-ink editorial line quality, bold outer contour, white interior space, and simplified bamboo mat.
- Keep the camera, crop, scale, anchor, and lighting fixed across all frames.
- Generate on a perfectly uniform green background, with no shadow, floor, texture, border, or text; the page owns the final background.
- Keep the hand anatomically stable. Only the rolling contact, sheet/filling occlusion, and roll state should change.
- Keep the bamboo mat as one context cue. Do not add a kitchen, chef, packaging, ingredients scattered around the frame, or extra props.

## Delivery decision

The budget check was run for a 640×427 CSS display, DPR 2, four viewport-heights of scroll, and both 144- and 192-frame candidates. Both passed temporal sampling but selected `chroma-video` because the equivalent Alpha atlas exceeds the one-sheet / decoded-memory budget. Reports:

- `Tools/oil-motion/build/gimbap-budget-random.json`
- `Tools/oil-motion/build/gimbap-budget-sequential.json`

Use the repository's WebGL chroma renderer and `interactive-motion.ts`. Keep a static Alpha poster for initial load, failed load, and `prefers-reduced-motion`.

## Next production pass

1. Create and approve K0–K3 keyframes using the current PNG as the style and final-state reference.
2. Generate three short transitions: K0→K1, K1→K2, and K2→K3.
3. Inspect every transition for hand anatomy, roll geometry, mat continuity, flicker, pauses, and reverse-playback quality.
4. Interpolate to the Motion Brief frame rate, compile the selected chroma-video asset, and wire a small explainer page before integrating into a larger brand page.

Do not generate the video until K0–K3 are visually approved; the repository's workflow treats the keyframes as the identity lock.
