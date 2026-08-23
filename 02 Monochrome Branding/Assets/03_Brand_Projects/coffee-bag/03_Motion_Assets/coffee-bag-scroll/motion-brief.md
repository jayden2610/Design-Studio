# Coffee Bag — Oil Motion prototype

## Intent

Make the product's value legible through one scroll-driven reveal: **sealed bag → opened bag → visible beans → aromatic payoff**.

## Storyboard

| Frame | Product state | Scroll meaning |
| --- | --- | --- |
| K0 | Sealed kraft coffee bag | A finished, premium product at rest. |
| K1 | Bag seal opened | Invitation to look inside. |
| K2 | Bag open with roasted beans visible | Proof of the product. |
| K3 | Open bag with beans rising above it | Sensory payoff. |

## Style lock

- Fixed front-facing, slight three-quarter product camera.
- Kraft paper with espresso-brown illustration, an empty cream label, and no brand copy.
- Identical product scale, composition, lighting, and paper-coloured page treatment across every keyframe.
- No hand, cup, scoop, surface, or scenery: the product is the entire visual story.

## Delivery

`demo.html` maps page scroll to 24 transparent, precomposed flipbook frames. It is a storyboard prototype, not a generated video; `prefers-reduced-motion` resolves to F23.

## No-video implementation

- `tools/build_flipbook.py` renders all 24 frames with Python and Pillow, so rebuilding does not consume model tokens or require an API key.
- K0 remains the fixed product body and receives only a restrained 4.5% camera push.
- K1 and K2 are clipped to the top 48% of the canvas, creating a protected state swap at the bag opening instead of crossfading whole product frames.
- Three bean components cut from K3 are independently translated and rotated during the final scroll range.

## Upgrade path: continuous video

If smoother deformation is worth the production cost, use K0 → K1, K1 → K2, and K2 → K3 as three separately generated video clips. Each clip should have the adjacent approved keyframes locked as its first and last frames, then be inspected, interpolated, trimmed, and compiled into a scroll-scrubbed video. Keep the existing keyframe page as the fallback and as the design reference.
