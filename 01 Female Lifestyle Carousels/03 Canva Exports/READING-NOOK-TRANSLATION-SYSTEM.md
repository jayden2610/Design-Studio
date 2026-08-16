# Reading Nook HTML-to-PPTX translation system

The editable PPTX builder is `reading-nook-weekend-photo-diary/tmp/build-canva-pilot.mjs`. Despite its retained pilot filename, it is now a content-driven Reading Nook builder: it reads any current pack's `content.json`, resolves its image paths, and translates `cover`, `collage`, and `list` layouts into native editable PPTX objects.

## Confirmed local builds

| Pack | Native PPTX | Local checks | Canva status |
| --- | --- | --- | --- |
| 01 Weekend Notes | `reading-nook-weekend-notes/output/Reading Nook Editorial - Weekend Notes - Canva Import.pptx` | Rendered, montage inspected, re-import verified, no overflow | Not imported |
| 02 Weekend Photo Diary | `reading-nook-weekend-photo-diary/output/Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx` | Source render, re-import inventory, tracking XML, overflow, and final render inspected | Not imported |
| 03 Camera Roll Dump | `reading-nook-camera-roll-dump/output/Reading Nook Editorial - Camera Roll Dump - Canva Import.pptx` | Rendered, montage inspected, re-import verified, no overflow | Not imported |

All three decks retain separate text, photo, wash, card, and counter objects. `Fraunces`/`Manrope` remain the specified PPTX typefaces and local font fallback/rendering means Canva remains the final typography authority.

## Rebuild a pack

```powershell
$root = 'C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels'
Set-Location "$root\02 Carousel Packs - Reading Nook Editorial"
node .\build-reading-nook.mjs '02 Weekend Photo Diary'

Set-Location "$root\03 Canva Exports\reading-nook-weekend-photo-diary\tmp"
node .\build-canva-pilot.mjs '02 Weekend Photo Diary'
& .\apply-character-spacing.ps1 '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
node .\verify-canva-pilot.mjs '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
```

For another Reading Nook pack, pass its name to the builder, then provide its exact generated PPTX path to `apply-character-spacing.ps1 -PptxPath`. Run `slides_test.py`, render all pages, inspect them beside the fresh HTML renders, and add the pack to the Canva import batch only after those checks pass.
