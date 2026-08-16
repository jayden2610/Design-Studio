# Handoff — follow-me-around Carousel

## 2026-08-10

### What we were building
A 5-slide linked Instagram carousel (1080×1350px) in a soft pastel/photo-journal style for the "follow me around — a day in my life" theme. User provided reference Canva carousel screenshots and wants the design to match that aesthetic (colored blocks, folder tabs, icons, speech bubbles) rather than being "text on photos."

### Current status
- **v1:** 5-slide scattered-text polaroid (scattered-text.html) — saved as draft
- **v2:** 5-slide linked carousel with per-slide font variety (Playfair, Dancing Script) — built but scored 22/50 in design review
- **User feedback:** "70% there, doesn't look like it'll hook me as an audience, wouldn't really want to swipe, not the best aesthetic"
- **Root cause identified:** carousel reads as "typography on photos" not a composed Canva-style graphic design. Missing colored blocks, folder tabs, icons, and a unified graphic system
- **Full design review + mitigation plan written** in `.commandcode/design/review-report.md`
- **Awaiting fresh session to rebuild** with the Canva-style graphic system

### What's done
- 31 reference photos classified into `with user/` (21) and `objects only/` folders
- 5 photos selected for the carousel
- Linked carousel mechanics built (progress bar, nav dots, keyboard/touch/swipe, smooth transitions)
- Design review completed with root cause analysis
- Habits reverse-engineered carousel saved as draft
- Local server running on port 8888

### What's next (rebuild spec)
Rebuild `follow-me-around.html` as a proper Canva-style composed carousel:

**Color system:**
- White blocks (#FFFFFF, 88-92% opacity) — text containers
- Sage green (#B8C4A8) — labels, CTAs, pill outlines
- Soft pink (#F4A5B8) — folder tabs, heart icons, content borders
- Dusty blue (#A1C4D0) — emotional/reflective statement blocks
- Cream (#F5F0D0) — scattered accent text only

**Slide-by-slide plan:**

| Slide | Photo | Layout | Colors | Key elements |
|-------|-------|--------|--------|-------------|
| 1 — Cover | anchor-user-identity | Scattered text + white block | Green checkmark ✓, white save pill, cream accents | 📁 above save pill, emoji trail, stars |
| 2 — 7:30 AM | 20-pack5-coffee | Pink-bordered white block (left), speech bubble | Pink border, ✏️ + ♥ icons | Folder tab "📁 morning", "made my coffee" |
| 3 — 1:00 PM | 24-pack6-park | Blue block + white speech bubble (left) | Dusty blue block, white text | Folder tab "📁 afternoon", "heading out" |
| 4 — 5:30 PM | 25-pack6-icecream | Sage block (right) + script accent | Sage green, warm golden overlay | Folder tab "📁 golden hour", ♥ icon |
| 5 — CTA | 30-pack7-library | Sage block left + bookmark | Sage green, white text | "follow along", 📁 "that's a wrap" |

**Critical rules:**
- Folder tab (📁 + category) on EVERY slide 2–5 — this is the glue
- Every interior slide uses a colored block behind text (no direct-on-photo text)
- Text shadows are secondary, not primary contrast
- One font system: Poppins Bold/ExtraBold + Dancing Script (accents only) + Montserrat SemiBold (labels)
- Drop Playfair Display
- Drop polaroid frame — all slides edge-to-edge

### Key decisions
- Only using `with user/` photos (person in frame)
- User wants first-person voice, not poetic/promotional
- User reviews HTML before any Canva export
- Canva API too limited for programmatic carousel creation — HTML previews are the workflow
- "that's a wrap" theme for slide 5 with library photo (woman looking back)

### Key files
- **Carousel HTML:** `C:\Users\angdo\Desktop\Carousel Design Studio\Carousel - Soft Pastels Style\follow-me-around.html`
- **Design review + mitigation plan:** `.commandcode/design/review-report.md`
- **Photos:** `female-lifestyle-ugc/with user/`
- **Reference carousels:** `reference carousels/photo_1.jpg`, `photo_2.jpg`, `photo_3.jpg`
- **Drafts:** `drafts/habits-carousel-draft.html`
- **Local server:** `http://localhost:8888`

### Photo-safe zones (don't cover the subject)
| Slide | Photo | Subject position | Safe zone |
|-------|-------|-----------------|-----------|
| 1 | anchor-user-identity | Woman centered, light bg | Corners, needs vignette |
| 2 | 20-pack5-coffee | Woman left, navy against white cabinets | LEFT side (dark zones) |
| 3 | 24-pack6-park | Person walking away, dark trees left | LEFT side (shadow) |
| 4 | 25-pack6-icecream | Woman left two-thirds, dark path bottom right | RIGHT + bottom right |
| 5 | 30-pack7-library | Woman centered, looking back, bookshelves | Bookshelves + top center |

### Copy (unchanged, user-approved)
- Slide 1: "follow me around / a day in my life" + emoji trail
- Slide 2: "7:30 am / made my coffee / my favorite part of the morning ♡"
- Slide 3: "1:00 pm / heading out / needed a change of scenery"
- Slide 4: "5:30 pm / little ice cream break / golden hour hit different today"
- Slide 5: "that's a wrap / thanks for coming along / follow for more days like this"

### Repo
`C:\Users\angdo\Desktop\Carousel Design Studio` → `github.com/jayden2610/carousel-design-studio`
