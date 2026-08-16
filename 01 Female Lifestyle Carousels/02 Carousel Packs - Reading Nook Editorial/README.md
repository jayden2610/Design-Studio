# Reading Nook Editorial Carousel Pack

This pack follows the Reading Nook Editorial contract and its four approved layout patterns.

## Image-first rule

Every layout decision must be made against the actual image used in the slide. Check the final crop before locking the type position.

- Use cocoa ink on light image areas and warm paper / white type only on dark areas.
- Add a subtle gradient, translucent paper wash, photo mat, or small caption card when the image does not provide enough separation.
- Keep the photo visible and the support layer editable.
- Move the type or change the crop before increasing opacity or adding multiple effects.
- Verify every headline and caption at mobile-preview size.

## References

- [Visual Contract](../../00%20Visual%20System/VISUAL-CONTRACT.md)
- [Layout Patterns](../../00%20Visual%20System/LAYOUT-PATTERNS.md)

The shared AI UGC source folder is documented at `../../01 Source Assets/lifestyle-ugc/README.md`.

## Current carousel packs

1. `01 Weekend Notes` — 4 slides
2. `02 Weekend Photo Diary` — 4 slides
3. `03 Camera Roll Dump` — 4 slides

Each pack contains `content.json`. Render one with:

`node .\\build-reading-nook.mjs "01 Weekend Notes"`

The older `Soft iOS Photo Diary` files remain archive material only; these packs are the current production sources.
