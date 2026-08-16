# Canonical Canva handoff runbook — Reading Nook Editorial

This is the approved production workflow: manually upload the already-QA-passed, native editable PPTX in Canva. It is intentionally manual because it is reliable and preserves the editable Canva result. Do not use a public file host for this private asset or the paused Connect API importer as a substitute.

## Import batch

Upload only:

1. `IMPORT-BATCH/Reading Nook Editorial - Weekend Notes - Canva Import.pptx`
2. `IMPORT-BATCH/Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx`
3. `IMPORT-BATCH/Reading Nook Editorial - Camera Roll Dump - Canva Import.pptx`

Each is a four-page 1080 × 1350 deck with intended editable `Fraunces` and `Manrope` text, separate hero/collage images, separate cards/washes/counters, and native DrawingML tracking.

## Canva actions

1. In Canva, create `Female Lifestyle Carousels — Etsy Templates`, then `01 Reading Nook Editorial`, then one numbered pack folder for each deck.
2. Upload one import-batch PPTX through Canva Uploads and open the created design. Do not batch-approve the other decks before this check passes.
3. Rename it `MASTER — Reading Nook Editorial — <NN Pack> — 1080x1350` and move it into that pack folder.
4. At 100% zoom, check every page against the matching local HTML source renders in `02 Carousel Packs - Reading Nook Editorial/<NN Pack>/output/`.
5. Confirm all titles, captions, metadata, list entries, counters, and eyebrow labels are individually editable; replace one hero image and each collage image.
6. Check the imported Fraunces/Manrope fonts, headline wrapping, letter spacing, caption-card widths, image crops, and detached counters. If Canva substitutes a font or does not preserve tracking, correct it in Canva and repeat the check on every page.
7. Duplicate the verified master. Rename the copy `EDIT THIS FIRST — Reading Nook Editorial — <NN Pack> — 1080x1350`.
8. Test the buyer/template link from a separate Canva account before publishing. Add the canonical buyer URL and QA date to `CANVA-TEMPLATE-INDEX.md` and `.csv`, then repeat for the next deck.

Do not mark the pack Canva-ready until all eight actions are complete.
