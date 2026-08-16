# Etsy release plan - Female Lifestyle Carousel Bundle

## What the buyer receives

One Etsy instant-download PDF. The PDF contains five buyer-safe Canva template links, one for each complete four-page carousel. Buyers do not receive the seller's Canva folder, editable master designs, PPTX files, or source assets.

The approved release set is 20 slides total:

1. Weekend Notes - 4 slides
2. Weekend Photo Diary - 4 slides
3. Camera Roll Dump - 4 slides
4. Nightstand Edit - 4 slides
5. Morning Pages - 4 slides

## Execution status - 12 August 2026

- [x] Seller-side root folder and Reading Nook pack folders exist in Canva.
- [x] Buyer copies exist for the three Reading Nook carousels.
- [x] Playful Scrapbook folders for Nightstand Edit and Morning Pages exist.
- [x] Buyer copies for Nightstand Edit and Morning Pages are created, named `EDIT THIS FIRST`, and moved to their private seller folders.
- [x] Etsy listing image set generated locally.
- [x] Etsy listing copy, image alt text, and customer-support replies prepared locally.
- [x] Buyer access-PDF generator prepared locally; it rejects placeholders so it cannot be uploaded before safe links exist.
- [ ] Generate the five Canva template links. This account currently shows the feature as Canva Business-only.
- [ ] Create the final clickable buyer-access PDF after all five template links exist.
- [ ] Test every link in a separate Canva account or an incognito session.
- [ ] Create the Etsy draft, upload the final PDF and listing images, then publish.

## The concrete next steps after Canva Business is enabled

1. Open each `EDIT THIS FIRST` design in Canva.
2. Select **Share > Template link** and copy the link. Do not use `Copy link`, `Public view link`, or an edit-share link.
3. Put the five links into `template-links.json` using `template-links.example.json` as the schema.
4. Generate the final access PDF using the supplied link map.
5. In a separate Canva account, open every link and verify **Use template** creates a fresh copy without changing the seller's buyer copy.
6. Upload only the final `Female-Lifestyle-Carousel-Templates-Access.pdf` to Etsy as an instant digital download.
7. Upload the images in `listing-images/` as the listing gallery. Set `01-main-listing-image.png` as the thumbnail.
8. Add the listing copy in `ETSY-LISTING-COPY.md`, save a draft, and check the live preview on desktop and mobile before publishing.

## Do not do these things

- Do not share the `Female Lifestyle Carousels - Etsy Templates` Canva folder with buyers.
- Do not expose any `MASTER` design, raw asset, PPTX, HTML source, or normal edit link.
- Do not upload the access PDF until every template link has passed the separate-account test.
- Do not include Happy Girl Era: it is not imported as a buyer-ready Canva design.
- Complete `PRE-LAUNCH-OWNER-CHECKLIST.md` before using the final Canva Business step.
