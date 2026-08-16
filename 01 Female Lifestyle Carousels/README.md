# Female Lifestyle Carousels — Project Init

This workspace contains the active female-lifestyle carousel systems, reusable source assets, HTML prototypes, editable PPTX builds, Canva handoffs, and archived experiments.

## Production rule

HTML is the visual source of truth. PPTX is the editable translation layer. Canva is the final buyer-facing source of truth.

## Publishing content source

The actual Instagram content that needs to be pushed out should be taken from:

`C:\Users\angdo\Personal Brand\Instagram\Female Lifestyle Content`

Use that folder as the source for publishable content. This workspace is for creating, editing, packaging, and QA-ing the carousel designs and templates; do not treat its working files or previews as the publishing queue.

Use this sequence for every new carousel pack:

`HTML/CSS → rendered PNG QA → native editable PPTX → PPTX QA → Canva import → Canva QA → single-folder handoff`

Do not skip the HTML approval step or build the Canva version from a stale PPTX.

### Locked Canva handoff decision

The production path is **manual Canva upload of the verified native-element PPTX**. This is the approved, buyer-safe path because Canva preserves the editable text, images, shapes, and page structure from the verified deck.

The experimental `03 Canva Exports/canva-connect-importer/` is paused. Do not use its OAuth/API workflow for production or delay a release while troubleshooting it. The only required seller action after local QA is: upload the PPTX in Canva, check the imported pages, make a buyer copy/template link, and test that buyer access separately.

## Typography default

- Editorial display/headline: **Fraunces**.
- Utility labels, metadata, counters: **Manrope**.
- Project font installer: `03 Canva Exports/reading-nook-weekend-photo-diary/tmp/install-project-fonts.ps1`.
- The open-source project font set is installed in the Windows user-font directory. Canva still needs an account-side check because font availability can differ by account and plan.

Choose the final font system before scaling a design across multiple packs. If the font changes, rerender HTML, rebuild PPTX, reapply tracking, and repeat QA.

## Editable PPTX contract

Every Canva-ready PPTX must keep these as native editable objects:

- text boxes for headlines, captions, metadata, list items, and counters;
- separate image layers or replaceable photo frames;
- separate card, wash, pill, and counter shapes;
- intentional character tracking stored in valid DrawingML (`spc` on `a:rPr`/`a:defRPr`, never an `<a:spc>` child);
- no full-slide flattening unless a specific effect cannot be represented natively.

## Standard QA loop

1. Render every HTML page.
2. Inspect each HTML page at full size.
3. Build the native PPTX with `@oai/artifact-tool` from JavaScript ES modules.
4. Render and inspect every PPTX slide against its HTML counterpart.
5. Re-import the PPTX and inspect text, shape, image, and notes objects.
6. Check card widths, line breaks, title ascent, character spacing, image crops, overlaps, clipping, and counters.
7. Update the pack QA file with the final font system, dimensions, known caveats, and exact commands.
8. Import only the verified PPTX into Canva and perform the final account-side check.

For the Reading Nook pilot, the fast loop is:

```powershell
cd "C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels\02 Carousel Packs - Reading Nook Editorial"
node .\build-reading-nook.mjs '02 Weekend Photo Diary'

cd "..\03 Canva Exports\reading-nook-weekend-photo-diary\tmp"
node .\build-canva-pilot.mjs '02 Weekend Photo Diary'
& .\apply-character-spacing.ps1 '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
node .\verify-canva-pilot.mjs '..\output\Reading Nook Editorial - Weekend Photo Diary - Canva Import.pptx'
```

## Canva single-folder packaging plan

Create one top-level Canva folder named:

`Female Lifestyle Carousels — Etsy Templates`

Inside it, keep this structure:

- `00 START HERE — Template Index`
- `01 Reading Nook Editorial`
- `02 Playful Scrapbook Social`
- `03 Soft iOS Photo Diary`
- `99 Archive — Do Not Sell`

Inside each active system folder, keep one folder per completed pack. For example:

`01 Reading Nook Editorial/01 Weekend Photo Diary`

Each pack folder should contain:

- one editable Canva design with the final pages;
- one `EDIT THIS FIRST` duplicate or buyer-facing template copy;
- a short Canva doc/page explaining how to duplicate, replace photos, edit text, and export;
- the matching preview PNGs for internal QA only, not as the primary editable deliverable;
- a note with the source pack name, font pair, page count, and Canva edit/template link.

Do not mix source packs, legacy versions, or experimental designs in the active sales folders. Keep local source assets and PPTX files in this workspace; Canva should contain the clean buyer-facing design organization.

## Next steps to get everything into Canva

1. Build and approve one complete system at a time, starting with the Reading Nook Editorial packs.
2. Import each verified PPTX into Canva as a separate editable design.
3. Create the top-level Canva folder and the numbered system subfolders above.
4. Move each imported design into its matching pack folder and rename it consistently.
5. Duplicate each design into a buyer-facing template copy if the original is your master.
6. Open every design in Canva and verify Fraunces/Manrope, editable text, replaceable images, page size, line wraps, and counters.
7. Create the `00 START HERE — Template Index` with links to each finished template and a short buyer instruction page.
8. Test one duplicated template in a separate Canva account before listing it on Etsy.
9. Export listing previews and a short PDF instruction sheet only after the Canva checks pass.

Use Canva's normal local upload flow for verified private PPTX files, then use the Canva UI for folder organization, buyer-copy creation, and final QA. Do not use the paused Connect API importer as a release dependency. Font behavior, duplicate/template settings, and final editability must still be checked in Canva itself.

## Current systems

- **Reading Nook Editorial** — `00 Visual System/VISUAL-CONTRACT.md` and `00 Visual System/LAYOUT-PATTERNS.md`.
- **Playful Scrapbook Social** — `00 Visual System/PLAYFUL-SCRAPBOOK-SOCIAL-CONTRACT.md` and `00 Visual System/PLAYFUL-SCRAPBOOK-SOCIAL-PATTERNS.md`.
- Both systems may use the shared AI UGC photography in `01 Source Assets/lifestyle-ugc`, but their visual rules must not be mixed within one carousel.
- The negative-space Weekend Series is archived for now and is not part of either active system.

## Folder map

- `00 Visual System` — both active contracts and their layout patterns.
- `01 Source Assets` — approved lifestyle photography, the AI UGC usage map, and reusable sticker assets.
- `02 Carousel Packs - Reading Nook Editorial` — the reading-nook carousel pack and its build files.
- `02 Carousel Packs - Soft iOS Photo Diary` — the main photo-diary kit, prototypes, import files, and exports.
- `99 Archive` — superseded prototypes, the negative-space experiment, and source ZIP/preview files.

Keep new work inside an existing active pack or create a new pack under `02 Carousel Packs - ...`. Do not add numbered chronological folders at the root.
