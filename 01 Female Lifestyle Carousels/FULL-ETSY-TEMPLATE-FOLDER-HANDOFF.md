# Full Etsy Template Folder — Production Handoff

**Last updated:** 12 August 2026  
**Project root:** `C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels`  
**Operating rule:** HTML/CSS is the visual source of truth. Native editable PPTX is the translation layer. Canva is the final buyer-facing source of truth.

**Canva import decision:** use the normal Canva upload UI for each locally verified PPTX, then complete Canva QA and buyer-copy/template-link testing. The Connect API importer is an experiment only and is paused; it is not a production dependency.

This handoff explains exactly how to finish, organize, verify, and deliver the full Female Lifestyle Carousels Etsy template folder. It is written for a future operator who should be able to continue without re-auditing the project.

---

## 1. Current state — what is real today

### Canva folder structure already created

Top-level folder: [Female Lifestyle Carousels — Etsy Templates](https://www.canva.com/folder/FAHSEeAp90o)

```text
Female Lifestyle Carousels — Etsy Templates
├── 00 START HERE — Template Index
├── 01 Reading Nook Editorial
│   └── 02 Weekend Photo Diary
│       ├── MASTER — Reading Nook Editorial — 02 Weekend Photo Diary — 1080x1350
│       └── EDIT THIS FIRST — Reading Nook Editorial — 02 Weekend Photo Diary — 1080x1350
├── 02 Playful Scrapbook Social
└── 99 Archive — Do Not Sell
```

Direct Canva links:

- [Weekend Photo Diary folder](https://www.canva.com/folder/FAHSETcZTaA)
- [Weekend Photo Diary master](https://www.canva.com/d/6KZ94i7zf4PgeMK)
- [Weekend Photo Diary buyer copy — EDIT THIS FIRST](https://www.canva.com/d/TjyK6bVKZohCFwB)

The root, Start Here, Reading Nook, Playful Scrapbook, archive, and Weekend Photo Diary folders are confirmed in Canva. Do **not** say the remaining pack folders exist until they have actually been created in Canva.

### Verified Canva pilot

`Reading Nook Editorial / 02 Weekend Photo Diary` is the only pack that has completed Canva import and visual/editability verification.

Verified facts:

- 4 pages at 1080 × 1350 / 4:5.
- Canva visuals were checked against the approved HTML source: warm paper, cocoa ink, muted olive, photography, image wash treatment, caption-card tone, and page-specific color direction match.
- Canva shows separate text, photo/image, card/wash, and counter layers. The intended editorial serif direction survives in Canva much more faithfully than in the local PPTX renderer.
- A master and a buyer-facing duplicate exist and are correctly named/foldered.

Still outstanding:

- Test the buyer copy in a separate Canva account.
- Create the buyer-facing `00 START HERE — Template Index` Canva document/design.
- Create an Etsy-safe template/share link only after the separate-account test passes.

### Local packs and readiness

| System | Pack | Pages | HTML | PPTX | Canva |
| --- | --- | ---: | --- | --- | --- |
| Reading Nook Editorial | 01 Weekend Notes | 4 | Approved | Locally QA-verified | Not imported |
| Reading Nook Editorial | 02 Weekend Photo Diary | 4 | Approved | Locally QA-verified | Imported and verified |
| Reading Nook Editorial | 03 Camera Roll Dump | 4 | Approved | Locally QA-verified | Not imported |
| Playful Scrapbook Social | 01 Happy Girl Era | 5 | Approved | Not built | Not imported |
| Playful Scrapbook Social | 02 Nightstand Edit | 4 | Approved | Not built | Not imported |
| Playful Scrapbook Social | 03 Morning Pages | 4 | Approved | Not built | Not imported |
| Soft iOS Photo Diary | legacy packs | 5 each | Archive only | Legacy only | Do not sell |

The canonical local tracker is [03 Canva Exports/Canva Delivery Package/CANVA-TEMPLATE-INDEX.md](03%20Canva%20Exports/Canva%20Delivery%20Package/CANVA-TEMPLATE-INDEX.md). Update this file and its CSV companion after every Canva action.

---

## 2. Non-negotiable production rules

1. **Never treat a PPTX render as the final appearance.** HTML is the design reference; Canva is the buyer-facing fidelity check.
2. **Never flatten a whole carousel page merely to force visual similarity.** Keep visible text, replaceable photos, cards, washes, labels, list items, and counters as separate editable Canva/PPTX elements.
3. **Do not mix active systems.** Reading Nook and Playful Scrapbook have different visual contracts; assets may be shared, but their typography, color logic, and composition rules may not be blended inside a pack.
4. **Do not use legacy Soft iOS files in active Etsy folders.** They are reference/archive material and use superseded directions.
5. **Do not use a public file host for private source, PPTX, or buyer assets.** For a local PPTX, use Canva’s normal upload UI.
6. **Do not claim a design, folder, template link, or buyer test is complete without Canva-side evidence.** Local files and PPTX QA are not enough.
7. **Keep the master private.** Buyers receive or are linked to `EDIT THIS FIRST`, never the editable master.
8. **If any source HTML changes, rebuild the deck from scratch.** Do not patch an old PPTX and assume it is current.

---

## 3. Locked visual systems

### Reading Nook Editorial

Sources of truth:

- [Visual contract](00%20Visual%20System/VISUAL-CONTRACT.md)
- [Layout patterns](00%20Visual%20System/LAYOUT-PATTERNS.md)
- [Reading Nook pack README](02%20Carousel%20Packs%20-%20Reading%20Nook%20Editorial/README.md)

Use:

- **Fraunces** for editorial headlines, short reflective copy, and list copy.
- **Manrope** for eyebrow labels, metadata, counters, and utility copy.
- Warm paper `#FBF3E6`, cocoa ink `#342E3F`, muted olive `#9CA274`, with restrained blush/powder-blue/pale-lilac accents only where the source supports them.
- 64–80 px margin logic at 1080 × 1350.
- Quiet, warm, lived-in, image-first compositions.
- Editable support layers for contrast: a wash, a paper card, or a small photo mat — not heavy opaque panels.

Approved layout types:

1. Full-bleed editorial cover.
2. Full-bleed captioned story.
3. Notes/list card over photography.
4. Split-image collage.

The current Reading Nook packs are intentionally four-page carousels. Do not force an unnecessary fifth page.

### Playful Scrapbook Social

Sources of truth:

- [Visual contract](00%20Visual%20System/PLAYFUL-SCRAPBOOK-SOCIAL-CONTRACT.md)
- [Layout patterns](00%20Visual%20System/PLAYFUL-SCRAPBOOK-SOCIAL-PATTERNS.md)
- [Playful pack README](02%20Carousel%20Packs%20-%20Playful%20Scrapbook%20Social/README.md)

The system may use clustered stickers/tape/paper treatments, but every decision remains image-first. Use the system’s own deep berry, butter, cocoa, cream, sticker, and composition rules. Do not borrow Reading Nook’s quiet editorial card language and call it Playful Scrapbook.

---

## 4. File map and what each location is for

```text
00 Visual System/
  Active visual contracts and layout rules.

01 Source Assets/
  Approved shared AI UGC photography and asset documentation.

02 Carousel Packs - Reading Nook Editorial/
  HTML/content sources for Weekend Notes, Weekend Photo Diary, Camera Roll Dump.

02 Carousel Packs - Playful Scrapbook Social/
  HTML/content sources for Happy Girl Era, Nightstand Edit, Morning Pages.

03 Canva Exports/
  Editable PPTX builds, local QA renders, Canva QA records, delivery package.

03 Canva Exports/Canva Delivery Package/
  Clean local mirror of the buyer-facing Canva delivery system.
  Never put tmp files, HTML, debug render files, pre-tracking decks, or raw source assets here.

99 Archive/
  Superseded and non-selling work only.
```

The `Canva Delivery Package` is intentionally clean:

```text
Canva Delivery Package/
├── CANVA-TEMPLATE-INDEX.md       # human-readable production status and URLs
├── CANVA-TEMPLATE-INDEX.csv      # sortable version of the same tracker
├── MANUAL-CANVA-RUNBOOK.md       # concise Canva execution checklist
└── IMPORT-BATCH/                 # only current locally verified final PPTX files
```

---

## 5. Reading Nook production workflow — repeat exactly

### Step A — refresh and inspect the HTML source

From the project root:

```powershell
$root = 'C:\Users\angdo\Desktop\Carousel Design Studio\01 Female Lifestyle Carousels'
Set-Location "$root\02 Carousel Packs - Reading Nook Editorial"
node .\build-reading-nook.mjs '01 Weekend Notes'
```

Replace `01 Weekend Notes` with the pack being built. Confirm all HTML PNG pages are current under that pack’s `output/` folder. Open every render and inspect it at full size before creating or importing a PPTX.

Check in this order:

- Actual image crop and text contrast.
- Headline line breaks and Fraunces character.
- Paper/card/wash colors and opacity.
- Caption card width and internal padding.
- Page number position.
- List card height and spacing, if applicable.
- No text over faces, hands, books, mugs, or visual story anchors.

### Step B — build editable PPTX translation

The content-driven Reading Nook translator is:

`03 Canva Exports/reading-nook-weekend-photo-diary/tmp/build-canva-pilot.mjs`

Despite the filename, it now accepts any active Reading Nook pack and reads the pack’s `content.json`.

```powershell
Set-Location "$root\03 Canva Exports\reading-nook-weekend-photo-diary\tmp"
node .\build-canva-pilot.mjs '01 Weekend Notes'
```

The output belongs in the pack-specific local export root:

- Weekend Notes: `03 Canva Exports/reading-nook-weekend-notes/output/`
- Weekend Photo Diary: `03 Canva Exports/reading-nook-weekend-photo-diary/output/`
- Camera Roll Dump: `03 Canva Exports/reading-nook-camera-roll-dump/output/`

The final deck naming convention is:

`Reading Nook Editorial - <Pack Name> - Canva Import.pptx`

### Step C — apply native editable tracking

Run the tracking script against the **exact final deck**. The PPTX path is required deliberately; this prevents accidentally patching a different pack.

```powershell
& .\apply-character-spacing.ps1 '<absolute path to Reading Nook Editorial - <Pack Name> - Canva Import.pptx>'
```

Tracking contract:

- Title: `spc="-263"`.
- Eyebrow: `spc="195"`.
- Metadata: `spc="135"`.
- Tracking belongs on `a:rPr` and/or `a:defRPr` attributes.
- An `<a:spc>` child node is invalid for this workflow and must never be created.

### Step D — local QA gate

Do all four checks before Canva upload.

1. Re-import structural verification:

```powershell
node .\verify-canva-pilot.mjs '<absolute path to final pptx>'
```

Expected result: 4 slides with editable titles, eyebrows, counter text, card/list layers, and image layers.

2. Overflow test:

```powershell
& 'C:\Users\angdo\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' `
  'C:\Users\angdo\.codex\plugins\cache\openai-primary-runtime\presentations\26.805.11740\skills\presentations\container_tools\slides_test.py' `
  '<absolute path to final pptx>'
```

Expected result: `Test passed. No overflow detected.`

3. Render all PPTX slides using the same presentation tooling.

4. Visually inspect each PPTX render beside its matching current HTML PNG. Use a montage only for consistency; inspect each page individually to catch text wrapping, missing overlays, cropped photos, detached counters, card geometry, or clipped typography.

Important limitation: the local PPTX renderer can resolve Fraunces differently from the HTML/Canva environment. Treat this local output as a layout and structure diagnostic. Canva is the final font/render authority.

### Step E — populate the private import batch

Copy only a locally passing final deck into:

`03 Canva Exports/Canva Delivery Package/IMPORT-BATCH/`

Never include:

- `pre-*.pptx` files;
- old pilot decks;
- source HTML;
- tmp scripts;
- raw UGC image libraries;
- QA screenshots or montages;
- legacy Soft iOS assets.

---

## 6. Canva import, QA, and delivery workflow

### Why this needs a manual upload

Use Canva’s normal local upload flow for private, locally verified PPTX files. Do not solve this by publishing files publicly or by attempting the paused Connect API importer.

### Process one pack at a time

For every approved PPTX:

1. Create the pack folder under its system folder if it does not yet exist.
2. Upload the final `Canva Import.pptx` through Canva Uploads.
3. Open the imported design immediately. Check all pages before moving on.
4. Rename the imported design:

   `MASTER — <System> — <NN Pack> — 1080x1350`

5. Move it to the matching Canva pack folder.
6. Compare every page at 100% against its current HTML source PNG.
7. Verify editability:
   - title;
   - eyebrow;
   - caption/body copy;
   - metadata;
   - list text and arrows;
   - counter;
   - hero photo;
   - each collage photo;
   - caption/list card and wash layer.
8. Verify visual fidelity:
   - Fraunces and Manrope availability;
   - title tracking and line breaks;
   - exact source color direction rather than a generic muted wash;
   - card width, opacity, border, and shadow;
   - photo crop;
   - counter placement;
   - no clipped or shifted elements.
9. Correct Canva-side differences before duplication. Common corrections are manual font choice, line breaks, letter spacing, photo crop, or card opacity.
10. Duplicate the approved master; name it:

    `EDIT THIS FIRST — <System> — <NN Pack> — 1080x1350`

11. Move the duplicate into the same pack folder.
12. Update the local Markdown and CSV indexes with the true Canva URLs, status, and QA date.
13. Test the buyer design/link from a separate Canva account. Only after that test can the pack be called buyer-ready.

### Current Canva naming rules

| Asset | Name template | Owner/access principle |
| --- | --- | --- |
| Internal source | `MASTER — <System> — <NN Pack> — 1080x1350` | Keep under the seller account; do not send buyers here. |
| Buyer copy | `EDIT THIS FIRST — <System> — <NN Pack> — 1080x1350` | Use this design/link for buyer testing and eventual delivery. |
| Buyer index | `START HERE — Female Lifestyle Carousels` | Links only to buyer copies and instructions; never masters. |

---

## 7. Recommended production order

The ordering is intentional: prove one system end-to-end before scaling it.

### Phase 1 — finish Reading Nook

1. **02 Weekend Photo Diary** — Canva import is complete. Finish separate-account buyer-link test and create Start Here index entry.
2. **01 Weekend Notes** — final PPTX is already in the private import batch. Upload, QA, master/copy, test, index.
3. **03 Camera Roll Dump** — same as Weekend Notes.

After these steps, `01 Reading Nook Editorial` can be sold as a cohesive three-pack collection, provided all three buyer links pass separate-account testing.

### Phase 2 — build the Playful Scrapbook translation system

Do **not** copy the Reading Nook PPTX builder blindly. First translate one pilot — `01 Happy Girl Era` is the best candidate because it has five pages and establishes whether the sticker/tape/photo treatment survives as editable Canva elements.

For the pilot:

1. Read the Playful contract/patterns.
2. Render and inspect current HTML.
3. Create a dedicated content-driven PPTX builder for its actual layout kinds.
4. Preserve each sticker, tape strip, paper card, photo, and text role separately where practical.
5. Perform the full HTML → PPTX → QA → Canva loop.
6. Only after the Happy Girl Era pilot is approved, extend the same structure to Nightstand Edit and Morning Pages.

### Phase 3 — Etsy packaging

Once at least one full system is buyer-tested:

1. Create the `00 START HERE — Template Index` Canva design.
2. Add a short `How to use these templates` page/design.
3. Prepare a concise PDF instruction sheet only after Canva checks are complete.
4. Export listing images from Canva, not from an old local PPTX preview.
5. Package the buyer-link instructions and listing assets for Etsy. Do not distribute the master link or local source files.

---

## 8. Start Here Canva index — required content

The existing Canva folder `00 START HERE — Template Index` is empty. Create one Canva design titled:

`START HERE — Female Lifestyle Carousels`

Use a simple warm-paper Reading Nook-compatible layout. This is an instruction/index asset, not a new decorative template system.

Suggested pages:

### Page 1 — Welcome

```text
Female Lifestyle Carousels
Editable Canva Templates

Choose a template, make your own copy, then swap the words and photos.
```

### Page 2 — How to edit

```text
1. Open the template link.
2. Click “Use template” or make a copy.
3. Replace photos by selecting a photo and choosing Replace.
4. Edit text by clicking any title, caption, label, or list item.
5. Download as PNG when you are ready to post.
```

### Page 3 — Font and layout note

```text
These designs use Fraunces for headlines and Manrope for supporting text.
Keep the existing line breaks and spacing for the cleanest result.
If you add more copy, widen the text box before shrinking the font.
```

### Page 4 onward — template index

For every buyer-tested pack, include:

- Pack name;
- System name;
- page count;
- a thumbnail/cover preview;
- direct link to its `EDIT THIS FIRST` buyer copy;
- a one-sentence use case.

Example entry:

```text
Weekend Photo Diary
Reading Nook Editorial · 4 pages
For personal updates, slower weekends, and camera-roll reflections.
Open editable template → [buyer copy link]
```

Keep source-preview PNGs only as small index thumbnails; buyers should always be directed to the Canva buyer copy.

---

## 9. Etsy release gate — do not skip

Every individual pack must pass all items below before a listing goes live.

### Product QA

- [ ] Current HTML source rendered and visually approved.
- [ ] PPTX rebuilt from the current source, not an older deck.
- [ ] PPTX tracking patch applied to the exact final deck.
- [ ] PPTX re-import verifier passes.
- [ ] PPTX overflow check passes.
- [ ] Final PPTX render inspected against every matching HTML page.
- [ ] Final deck exists in the correct local `IMPORT-BATCH` location.

### Canva QA

- [ ] Canva master is imported at 1080 × 1350.
- [ ] All pages are visually checked against HTML at 100%.
- [ ] Fonts, colors, image crop, transparency, card geometry, and counters are correct.
- [ ] Text, photos, cards, washes, counters, and list layers are editable.
- [ ] Master is named and moved into the correct Canva pack folder.
- [ ] Buyer copy is duplicated, named, and in the same folder.
- [ ] Real master/buyer links are recorded locally.
- [ ] Buyer copy works from a separate Canva account.

### Listing QA

- [ ] Start Here index contains the buyer link.
- [ ] Listing preview images come from the verified Canva design.
- [ ] Instructions explain editing and downloading clearly.
- [ ] Buyer receives buyer copy/template link only.
- [ ] Master and raw source assets stay private.

---

## 10. Common failure modes and the correct response

| Failure | Likely cause | Correct response |
| --- | --- | --- |
| PPTX colors/washes look generic locally | Artifact renderer approximates gradients/effects | Check against HTML, then verify actual Canva import. Do not flatten the page. |
| Canva headline wraps differently | Font substitution or different type metrics | Confirm Fraunces; adjust box width/line break before reducing type size. |
| Canva ignores imported character tracking | OOXML tracking unsupported/altered on import | Apply Canva letter spacing manually, then verify all pages. |
| Photo replacement exposes the original photo | Original photo was flattened into the page | Rebuild with native photo layers; do not ship. |
| Card feels too wide or creates a counter “nub” | Card/counter geometry drifted | Keep card width editorial and counter separate at lower right. |
| New PPTX does not resemble the latest source | Source HTML changed after PPTX export | Rerender HTML, rebuild PPTX, reapply tracking, rerun QA. |
| Cannot import local PPTX via connector | Connector limitation | Upload through normal Canva UI; never create a public host for private files. |
| Canva design exists but index says pending | Local tracker was not updated | Update Markdown and CSV immediately after verified Canva actions. |

---

## 11. Status ownership and maintenance routine

After every production session:

1. Update `CANVA-TEMPLATE-INDEX.md` and `.csv`.
2. Add relevant Canva link(s), not placeholder URLs.
3. Mark the exact QA state: local QA only, imported, Canva visual QA passed, buyer link tested, or Etsy ready.
4. Update the pack’s QA note with any Canva-specific font or spacing correction.
5. Keep only final buyer-facing assets in the clean local delivery package.
6. Leave legacy, backups, debug renders, scripts, and source photos outside buyer-facing Canva folders.

The project is considered fully complete only when every active pack has a verified master, buyer copy, separate-account template test, Start Here index entry, and Etsy listing package.
