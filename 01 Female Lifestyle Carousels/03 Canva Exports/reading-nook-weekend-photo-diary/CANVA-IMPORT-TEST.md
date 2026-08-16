# Canva import test — Reading Nook Editorial / Weekend Photo Diary

## Output

`output/Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx`

This is a four-page, 4:5 native editable PPTX generated from `02 Carousel Packs - Reading Nook Editorial/02 Weekend Photo Diary/content.json`. Its HTML render is the visual source of truth.

## Editable layer contract

- All visible copy is native text.
- The four collage photos are separate rounded image layers.
- Full-slide hero photos are separate image layers that can be replaced.
- Caption cards, list cards, counters, and eyebrow pills are separate shapes.
- List arrows and list text are separate editable text layers.
- Complex photo treatment is represented by separate translucent wash layers rather than baked into the text.

## Caption-card QA

- Cover caption cards are intentionally editorial rather than full-width UI panels: slide 1 uses a 760 px card and slide 4 uses an 860 px card.
- Card copy remains left-aligned with 30 px internal padding; the page counter is detached at the lower-right so it does not create a protruding overlap on the card.
- Keep the card widths and detached-counter placement when making future renders. If the copy changes substantially, adjust card width before reducing the body font.

## Canva QA checklist

1. Upload the PPTX to Canva and open it as a design.
2. Confirm the page size remains 4:5 / 1080 × 1350 proportion.
3. Click each title, caption, metadata line, list item, and counter number to verify editability.
4. Replace one full-slide photo and each of the four collage photos.
5. Check that the title does not wrap unexpectedly after editing.
6. Export one page as PNG and compare it against the source HTML render.
7. Test the resulting template link in a separate free Canva account.

## Canva verification — completed 12 August 2026

- Verified the four-page Canva import against the approved HTML source pages at 100% design scale: warm paper, cocoa ink, muted olive, image washes, card tones, and page-specific photography match the source direction.
- Confirmed Canva imported the visual hierarchy with Fraunces-style editorial headlines and distinct text/card/image layers on all four pages.
- Created the organized master and buyer copy in the `Female Lifestyle Carousels — Etsy Templates/01 Reading Nook Editorial/02 Weekend Photo Diary` Canva folder.
- Buyer edit copy: https://www.canva.com/d/TjyK6bVKZohCFwB
- Final buyer-link testing in a separate Canva account remains required before an Etsy listing is published.

## Font QA

The revised editorial variant uses:

- Headlines and caption/list copy: **Fraunces**, 88 px headlines / 27–28 px copy, with a restrained editorial serif character.
- Eyebrows, metadata, counters, and utility labels: **Manrope**, with Arial as the local fallback.

Fraunces and Manrope are installed in the local Windows user-font directory and are now used by the HTML renderer. The editable PPTX also stores the intended `Fraunces` and `Manrope` typefaces. Canva remains the final font check: confirm both fonts are available in the account and compare line breaks at 100% zoom before publishing the template. If Canva substitutes either font, treat that as a font-availability variant and recheck every card height and title wrap.

## Character-spacing / tracking QA

The HTML render uses intentional tracking, and the final PPTX stores it as the native DrawingML `spc` attribute on each editable text run:

- Headline/title: **−3.5 px** character spacing.
- Eyebrow labels: **+2.6 px**, encoded as `spc="195"`.
- Metadata labels: **+1.8 px**, encoded as `spc="135"`.
- Body copy and list text: **0 px** additional spacing.

Headline tracking: **-3.5 px**, encoded as `spc="-263"`.

The headline is encoded as `spc="-263"` (the OOXML equivalent of approximately -3.5 px at 96 dpi).

Do not add an `<a:spc>` child element; Canva/PowerPoint expects `spc` on `a:rPr` and `a:defRPr`. The local artifact renderer does not draw this attribute, so the local preview may show wider headlines and tighter utility text even though the PPTX XML is correct. Canva is the final account-side check: compare at 100% zoom and use the Letter spacing control only if Canva does not honor the imported `spc` values.

The current import PPTX has native editable tracking values on the title, eyebrow, and metadata runs.

## Verified local QA status

The current import PPTX was rebuilt after the source HTML render, passed the re-import object inventory, and passed `slides_test.py` with no detected overflow. All four rendered PPTX pages were visually inspected. The local artifact renderer visibly resolves the intended Fraunces headlines differently from the HTML renderer, so this does not substitute for the Canva-side font check.

## Repeatable fast render loop

From the export `tmp` folder, run the exporter, then apply the native tracking patch:

```powershell
node .\build-canva-pilot.mjs '02 Weekend Photo Diary'
& .\apply-character-spacing.ps1 '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
```

Then run the standard checks:

```powershell
& 'C:\Users\angdo\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' 'C:\Users\angdo\.codex\plugins\cache\openai-primary-runtime\presentations\26.805.11740\skills\presentations\container_tools\slides_test.py' '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
node .\verify-canva-pilot.mjs '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx' | Set-Content ..\output\final-import-verify.txt -Encoding utf8
```

The exporter includes the verified fixes for title ascent/line spacing, collage frame geometry, collapsed list spacing, long caption wrapping, and caption-card proportions. Keep the source HTML PNGs beside the PPTX for the visual comparison pass.

## Current limitation

The available Canva connection can organize and inspect Canva-side designs, but it does not expose an upload action for an arbitrary existing local PPTX path. Upload this private PPTX through Canva's normal upload flow for the final account-side fidelity check; do not use a public file host.
