# Production Path — Female Lifestyle Carousel Templates

## Locked decision

Use a hybrid workflow:

1. Prototype the visual system locally in HTML/CSS first.
2. Test UGC crops, typography, contrast, sticker scale, and story hierarchy in the prototype.
3. Rebuild the approved version natively in Canva.
4. In Canva, set each UGC image using **Set image as background**. Never insert a full-page image as an ordinary image element.
5. Keep text, image frames, and stickers as independent editable Canva layers above the page background.

## Non-negotiable background rule

`background` means the Canva page background. It must not be implemented with `insert_fill`, a resized image element, or a new image placed over the composition.

If the Canva connector cannot set the page background directly, stop at the HTML prototype and use Canva's editor manually for that step.

## Locked visual system

- Format: 1080 × 1350 px, 4:5.
- Direction: warm candid editorial real-life.
- Display: Cormorant Garamond.
- Utility/body: DM Sans.
- Ink: `#2F2925`.
- Accent: muted cocoa `#9D6A62`.
- UGC identity: warm natural light, lived-in interiors, coffee, books, flowers, bedding, and quiet routines.
- Sticker rule: maximum two meaningful stickers per page; stickers remain independent layers.

## Canva handoff checklist

- [ ] Set UGC image as page background.
- [ ] Confirm no cream/paper panel remains unless intentionally designed as a foreground card.
- [ ] Add editable text above the background.
- [ ] Add independent stickers above the background.
- [ ] Check contrast at mobile size.
- [ ] Duplicate the approved master before making the next template.
