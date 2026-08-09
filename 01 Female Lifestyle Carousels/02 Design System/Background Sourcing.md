# Background Sourcing — AI Prompt Templates + Curated Collections

Companion doc to `README.md`. Covers how to source backgrounds that already match a color combo's hue *before* any text/typography is applied — the fix that made posters 02/03/05 work in `html-built/14-color-combo-gallery.html`.

**Rule of thumb:** pick or generate the background from the palette's hex values first. Never generate a generic nature shot and hope it fits — tell the AI (or search query) the exact hue family up front.

---

## Part 1 — AI Generation Prompt Template

Use Midjourney, Flux (via Leonardo.ai free tier), or similar. Keep the base template fixed across a whole gallery so the series reads as one cohesive world — only swap the bracketed fields.

### Base template

```
cinematic nature photograph, [SCENE], [LIGHT], [HUE-LOCK], soft natural light,
shallow depth of field, muted film grain, no text, no people (unless specified),
4:5 aspect ratio, editorial photography, high detail
```

### Field guide

- **[SCENE]** — the physical location: misty mountain ridge / golden hour meadow / blue-hour coastline / desert dusk mesa / still forest lake / dry savanna grass / foggy pine forest / open ocean horizon
- **[LIGHT]** — the time-of-day that carries the hue: golden hour / blue hour / overcast diffused light / dusk afterglow / pre-dawn cool light / high-noon flat light
- **[HUE-LOCK]** — the explicit color constraint pulled from the combo's hex values, e.g. "deep indigo-blue sky and sea, no warm tones" or "cyan-to-violet twilight gradient, no green" — this is the field that prevents the AI from returning a generic shot that fights your palette

### Ready-to-use prompts for your 5 existing color combos

**01 — Wicked Green `#9ED14B` / Morrow White `#FBFBCC` / Orient Blue `#006887`**
```
cinematic nature photograph, sunlit meadow with tall grass, golden hour light,
fresh saturated green field against a deep teal-blue dusk sky, no warm orange
tones, soft natural light, shallow depth of field, muted film grain, no text,
4:5 aspect ratio, editorial photography, high detail
```

**02 — Orange Peach `#EFBB91` / Odious Orange `#FFE0C0` / Natural Indigo `#023441`**
```
cinematic nature photograph, open ocean horizon at blue hour, flat indigo sky
and sea meeting at the horizon line, no rock or land texture competing for
color, soft peach glow only at the horizon edge, muted film grain, no text,
4:5 aspect ratio, editorial photography, high detail
```

**03 — Covert Black `#16171C` / Sea Salt `#D9E4E8` / Vintage Aqua `#65ABC4`**
```
cinematic nature photograph, foggy mountain ridge at dawn, near-monochrome
blue-grey palette, dense fog and flat stone-grey sky, no green vegetation
visible, cool diffused overcast light, muted film grain, no text, 4:5 aspect
ratio, editorial photography, high detail
```

**04 — Darkout Brown `#331A0C` / Papaya Whip `#FDF1D5` / Fiery Coral `#E45D26`**
```
cinematic nature photograph, dry savanna grass field at dusk, warm campfire-
toned afterglow sky, deep umber brown shadows, no blue or cool tones, soft
natural light, shallow depth of field, muted film grain, no text, 4:5 aspect
ratio, editorial photography, high detail
```

**05 — Uranus Blue `#54D5F1` / Pink Lace `#FFDFF9` / Plum Burgundy `#621932`**
```
cinematic nature photograph, twilight sky at blue hour transitioning to deep
violet-plum at the horizon, cyan-blue upper sky fading to burgundy afterglow,
no green or land texture, open unobstructed sky, muted film grain, no text,
4:5 aspect ratio, editorial photography, high detail
```

### Iteration rule
Change one field at a time — same discipline as the README's "iterate by changing one variable only" rule for typography. Swap [SCENE] first if the mood's right but composition is wrong; swap [LIGHT] if mood's off; only touch [HUE-LOCK] last, since that's the field doing the palette-matching work.

---

## Part 2 — Curated Stock Collections (Pexels / Unsplash)

Organize a personal shortlist by hue family so you're picking from a pre-vetted set instead of searching cold each time. Suggested starting searches per family — save 5-6 winners from each into your own collection:

### Cool / Blue-Indigo family (combos 02, 05)
- Unsplash search: `"blue hour ocean horizon"`, `"twilight sky minimal"`, `"night sky gradient"`
- Pexels search: `"dusk sky ocean"`, `"blue hour landscape"`
- Look for: flat, unobstructed sky/water, minimal competing texture, gradient-like natural light

### Cool / Grey-Aqua monochrome family (combo 03)
- Unsplash search: `"foggy mountain ridge"`, `"misty forest monochrome"`, `"overcast coastline"`
- Pexels search: `"fog mountains grey"`, `"moody overcast landscape"`
- Look for: near-desaturated scenes, fog/mist doing the softening work, no green cast

### Warm / Green-Botanical family (combo 01)
- Unsplash search: `"sunlit meadow golden hour"`, `"tea plantation field"`, `"green field dusk"`
- Pexels search: `"meadow golden hour"`, `"green field sunset"`
- Look for: saturated but natural green, warm light without going full orange

### Warm / Brown-Coral-Savanna family (combo 04)
- Unsplash search: `"savanna dusk grass"`, `"dry field golden hour"`, `"desert sunset warm"`
- Pexels search: `"dry grass sunset"`, `"savanna golden hour"`
- Look for: umber/rust tones already present in the photo, no blue cast

### Building your own collection
1. Create a Pexels or Unsplash "Collection" (both support free account collections) named by hue family, e.g. "BG — Cool Indigo", "BG — Warm Savanna"
2. Save 5-6 shots per family — enough variety to avoid reusing the same photo across posters, few enough to stay curated rather than overwhelming
3. Before adding a shot, check it against the combo's hex values by eye — does the photo's dominant color already sit close to one of the three hexes? If you're fighting the photo's natural color to make it fit, skip it

---

## Part 3 — Post-Processing for Cohesion (mixed sources)

If combining AI-generated and stock photography in one gallery, run a light consistency pass so the series doesn't feel stitched together:
- Slight desaturation (-5 to -10%) across all images
- A subtle warm or cool grade shift toward the combo's dominant hue (Lightroom preset or Photoshop adjustment layer)
- Keep the CSS overlay/scrim system already in use in `html-built/*.html` — it's doing real work tying photo and type color together, not just decoration
