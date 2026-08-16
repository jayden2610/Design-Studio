# Paused experiment — Canva Connect PPTX Importer

**Status: paused; not part of the production workflow.**

The OAuth authorization flow could not be made dependable enough for this Etsy-template workflow. Do not run `authorize-import.mjs` or `import-pptx.mjs` for an active pack, and do not add Canva credentials, access tokens, or refresh tokens to this repository.

## Approved production workflow

1. Build and visually approve the HTML source.
2. Build and locally QA the native editable PPTX.
3. Upload that verified PPTX manually in Canva.
4. Check the imported pages, editable layers, fonts, line wrapping, and photo crops at 100%.
5. Keep the approved imported design as the seller master; duplicate it into `EDIT THIS FIRST` for the buyer flow.
6. Generate and separately test the buyer-safe Canva Template link before Etsy release.

This costs one short Canva upload/check per completed pack, but removes OAuth, token expiry, browser challenges, and integration-review risk. The source PPTX remains editable—this is not a flattened-image fallback.

## If this experiment is revisited

Use only the isolated `CONNECT API IMPORT TEST — DO NOT SELL` folder (`FAHSbYdCEKo`). Do not change the current master, buyer-copy, or Etsy-delivery workflow until a full pilot imports, moves, and passes Canva visual/editability QA consistently.
