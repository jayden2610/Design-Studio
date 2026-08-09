# Canva import workflow (HTML → Canva design)

Default method for getting any HTML build (sticker sheets, carousel mockups,
design system pages) into Canva as an editable design. Faster than manual
screenshot-and-recreate, and faster than copy-pasting elements one at a time
from a browser tab.

## Why HTML import over other paths

- `import-design-from-url` (Canva MCP tool) turns a URL into a real editable
  Canva design in one call — no manual re-building in the Canva UI.
- Annotate the source HTML with `data-document-role="page"` on every element
  that should become a Canva page (works even for a single page), plus
  optional `data-label="..."` for the page name and `data-speaker-notes="..."`.
  This is undocumented in Canva's public help center — it's only specified in
  the import tool's own description. Confirmed working 2026-08-09.
- Once imported, every `<img>` becomes an individual, independently
  selectable/copyable element in Canva — click, Ctrl+C, paste into any other
  design. This is what makes a sticker sheet actually usable as a sticker
  library instead of a static reference image.

## Hard requirements (confirmed by testing, 2026-08-09)

1. **Public HTTPS URL only.** The import tool refuses local file paths
   outright (`file://`, `C:\...`, etc.) — the file must already be fetchable
   over the open internet before the tool call.
2. **Google Drive share links do NOT work as-is.** The default
   `https://drive.google.com/uc?export=download&id=FILE_ID` link fails
   (`fetch_failed`, non-200) for anything beyond tiny files — Drive serves an
   HTML "can't scan for viruses" interstitial instead of the raw bytes.
   The working direct-download form is:
   ```
   https://drive.usercontent.google.com/download?id=FILE_ID&export=download&confirm=t
   ```
   Get `FILE_ID` from the share link (`.../d/FILE_ID/view?usp=sharing`).
3. **One self-contained HTML file beats a zip.** A zip of `index.html` +
   external image folders failed twice with a Canva-side `internal_error`
   (this was after the Drive fetch itself succeeded — the zip parsing/import
   step is what failed). A single HTML file with every image inlined as a
   base64 `data:` URI succeeded on the first try. Until Canva's zip import is
   retested and confirmed reliable, **default to inlining images.**
4. **Keep the payload well under ~10MB.** Nothing in this repo can push a
   multi-MB file to Drive without a human doing the actual upload (agent tool
   calls cap out around 200-300KB of text, and base64 has ~1.37x overhead) —
   so images need to be downsized before embedding, not after. See recipe
   below.

## Build recipe

1. Write the design as plain HTML — one `<div data-document-role="page">`
   wrapper per Canva page, real `<img>` tags for every sticker/element you
   want individually selectable in Canva (not CSS backgrounds — those don't
   import as separate elements).
2. Resize source images before embedding. 500px max dimension is plenty for
   stickers meant to be copy-pasted at small-to-medium size in a carousel —
   this took the sticker library from 27MB → 5.5MB of source PNGs. Use
   Pillow (`im.thumbnail((500, 500), Image.LANCZOS)`, save with
   `optimize=True`) or equivalent.
3. Inline every image as base64: replace `src="path/to/img.png"` with
   `src="data:image/png;base64,<...>"`. Keep original relative-path HTML
   as the canonical version in the repo (git-friendly, human-readable); build
   the inlined version as a throwaway artifact for import only — don't check
   the inlined HTML into git, it's a generated blob.
4. Human uploads the inlined HTML to their own Google Drive, sets sharing to
   "Anyone with the link," and pastes the share link back.
5. Convert the share link to the `drive.usercontent.google.com` direct-link
   form (step 2 above) and call `import-design-from-url` with
   `intended_design_type` matching the content (use `other` if none of the
   enum values fit — sticker sheets, reference grids, etc. don't map cleanly
   to Canva's design-type list).
6. Confirm the returned `edit_url` opens with every image as a separate,
   click-to-select element — that's the signal the import actually worked as
   a "library," not just a static picture import.

## Open question / next thing to test

Whether Canva's zip import can be made to work reliably (would remove the
"resize + inline + regenerate a throwaway blob" step entirely and let the
canonical relative-path HTML be imported directly). Two attempts both failed
with the same `internal_error`; untested whether a smaller zip, a different
folder structure, or an explicit content-type on upload changes that. Until
retested and confirmed, treat zip import as unreliable and use the
single-file-inlined-HTML method above.
