import fs from "node:fs/promises";
import { Presentation, PresentationFile } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs";

const outDir = "C:/Users/angdo/Desktop/Carousel Design Studio/01 Female Lifestyle Carousels/05 Soft iOS Photo Diary Carousel Kit/tmp-weekend-deck/output";
const finalPptx = "C:/Users/angdo/Desktop/Carousel Design Studio/01 Female Lifestyle Carousels/05 Soft iOS Photo Diary Carousel Kit/Weekend Photo Diary — 5-Slide Mock Carousel.pptx";
const sourceImage = "C:/Users/angdo/AppData/Local/Temp/codex-clipboard-bf431b12-df63-40f0-bc83-d663f916ba94.png";
const W = 1080, H = 1350;
const C = { paper: "#F8F5F2", cream: "#FFF9F2", blush: "#F4D8D5", blue: "#DCEAF2", lilac: "#E6DDED", ink: "#343338", cocoa: "#9D6A62" };

async function blob(path, data) { await fs.writeFile(path, new Uint8Array(await data.arrayBuffer())); }
function shape(slide, geometry, left, top, width, height, fill, line = { style: "solid", fill: "none", width: 0 }, radius) {
  return slide.shapes.add({ geometry, position: { left, top, width, height }, fill, line, ...(radius ? { borderRadius: radius } : {}) });
}
function text(slide, value, left, top, width, height, style) {
  const item = shape(slide, "textbox", left, top, width, height, "none");
  item.text = value;
  item.text.style = style;
  return item;
}
function eyebrow(slide, value, left = 78, top = 78) {
  return text(slide, value, left, top, 700, 30, { fontSize: 18, bold: true, color: C.cocoa, typeface: "DM Sans" });
}
function title(slide, value, left = 78, top = 142, width = 650, height = 240, size = 86) {
  return text(slide, value, left, top, width, height, { fontSize: size, color: C.ink, typeface: "Playfair Display", lineSpacing: 0.9 });
}
function body(slide, value, left, top, width, height, size = 28, color = C.ink) {
  return text(slide, value, left, top, width, height, { fontSize: size, color, typeface: "DM Sans", lineSpacing: 1.2 });
}
function photoSlot(slide, label, left, top, width, height, rounded = true) {
  shape(slide, rounded ? "roundRect" : "rect", left, top, width, height, C.cream, { style: "solid", fill: C.cocoa, width: 2 }, rounded ? "rounded-2xl" : undefined);
  text(slide, label.toUpperCase(), left + 24, top + height / 2 - 16, width - 48, 32, { fontSize: 15, bold: true, color: C.cocoa, typeface: "DM Sans", alignment: "center" });
}
function tag(slide, value, left, top, width = 220) {
  shape(slide, "roundRect", left, top, width, 54, "none", { style: "solid", fill: C.cocoa, width: 2 }, "rounded-2xl");
  text(slide, value, left + 14, top + 16, width - 28, 22, { fontSize: 15, bold: true, color: C.cocoa, typeface: "DM Sans", alignment: "center" });
}

async function main() {
  await fs.mkdir(outDir, { recursive: true });
  const deck = Presentation.create({ slideSize: { width: W, height: H } });
  const imageBytes = await fs.readFile(sourceImage);

  // 01 — Hook
  let s = deck.slides.add(); s.background.fill = C.paper;
  eyebrow(s, "WEEKEND PHOTO DIARY");
  title(s, "a weekend\nthat felt like\na deep breath", 78, 146, 410, 300, 72);
  shape(s, "rect", 78, 475, 88, 4, C.cocoa);
  body(s, "sunlight, slow pages, and nowhere urgent to be.", 78, 512, 350, 130, 30);
  body(s, "swipe for the little moments →", 78, 720, 370, 46, 21, C.cocoa);
  text(s, "[CITY] · [MONTH] · [YEAR]", 78, 1204, 500, 34, { fontSize: 18, bold: true, color: C.cocoa, typeface: "DM Sans" });
  shape(s, "rect", 737, 338, 184, 48, C.blush, { style: "solid", fill: "none", width: 0 });
  s.images.add({ blob: imageBytes, contentType: "image/png", alt: "User-provided sunlit reading lifestyle image", fit: "cover", position: { left: 507, top: 370, width: 495, height: 655 }, geometry: "roundRect", borderRadius: "rounded-xl" });
  shape(s, "ellipse", 875, 1145, 120, 82, "none", { style: "solid", fill: C.cocoa, width: 3 });

  // 02 — Moments
  s = deck.slides.add(); s.background.fill = C.blue;
  eyebrow(s, "01 · LITTLE MOMENTS");
  title(s, "a few things\ni want to remember", 78, 142, 640, 200, 80);
  body(s, "the kind of moments that make a weekend feel longer in the best way.", 78, 382, 425, 120, 28);
  photoSlot(s, "drop photo 01", 78, 700, 405, 510);
  photoSlot(s, "drop photo 02", 597, 350, 405, 575);
  shape(s, "roundRect", 635, 985, 320, 185, C.cream, { style: "solid", fill: "none", width: 0 }, "rounded-2xl");
  text(s, "A LITTLE NOTE", 675, 1024, 230, 28, { fontSize: 17, bold: true, color: C.cocoa, typeface: "DM Sans", alignment: "center" });
  body(s, "“more slow mornings, please.”", 676, 1070, 235, 70, 21);
  shape(s, "rect", 115, 667, 170, 46, C.blush);

  // 03 — Notes
  s = deck.slides.add(); s.background.fill = C.blush;
  eyebrow(s, "02 · THE LITTLE THINGS");
  title(s, "small favourites\nfrom lately", 78, 142, 700, 190, 80);
  shape(s, "roundRect", 78, 422, 555, 610, C.cream, { style: "solid", fill: "none", width: 0 }, "rounded-2xl");
  text(s, "THIS WEEKEND:", 123, 469, 250, 28, { fontSize: 18, bold: true, color: C.cocoa, typeface: "DM Sans" });
  const notes = ["01  [a book / a place / a tiny ritual]", "02  [a meal / a moment / a thought]", "03  [something i want to do again]", "04  [a song on repeat]"];
  notes.forEach((n, i) => { body(s, n, 123, 535 + i * 112, 440, 45, 23); if (i < 3) shape(s, "rect", 123, 592 + i * 112, 420, 1, "#D8D1CB"); });
  photoSlot(s, "drop photo 03", 695, 490, 307, 307);
  tag(s, "SAVE THIS FEELING", 720, 865, 250);

  // 04 — Collage
  s = deck.slides.add(); s.background.fill = C.lilac;
  eyebrow(s, "03 · CAMERA ROLL");
  title(s, "four frames\nfrom the weekend", 78, 142, 720, 190, 80);
  photoSlot(s, "drop photo 04", 78, 390, 432, 380, false);
  photoSlot(s, "drop photo 05", 570, 390, 432, 380, false);
  photoSlot(s, "drop photo 06", 78, 835, 432, 380, false);
  photoSlot(s, "drop photo 07", 570, 835, 432, 380, false);
  shape(s, "rect", 405, 367, 230, 46, C.blush);
  text(s, "[ADD DATE STAMP]", 756, 1240, 246, 26, { fontSize: 16, bold: true, color: C.cocoa, typeface: "DM Sans", alignment: "right" });

  // 05 — Close
  s = deck.slides.add(); s.background.fill = C.paper;
  eyebrow(s, "04 · UNTIL NEXT TIME");
  title(s, "until the next\nlittle weekend", 78, 142, 670, 190, 80);
  body(s, "[one closing thought that feels true to you.]", 78, 375, 530, 82, 29);
  tag(s, "SAVE FOR LATER", 778, 144, 224);
  photoSlot(s, "drop landscape photo", 78, 690, 924, 410);
  text(s, "WEEKEND PHOTO DIARY · [YOUR HANDLE]", 78, 1215, 600, 28, { fontSize: 17, bold: true, color: C.cocoa, typeface: "DM Sans" });
  shape(s, "ellipse", 848, 276, 130, 82, "none", { style: "solid", fill: C.cocoa, width: 3 });

  for (const [i, slide] of deck.slides.items.entries()) await blob(`${outDir}/slide-${i + 1}.png`, await deck.export({ slide, format: "png", scale: 1 }));
  await blob(`${outDir}/montage.webp`, await deck.export({ format: "webp", montage: true, scale: 1 }));
  const pptx = await PresentationFile.exportPptx(deck); await pptx.save(finalPptx);
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
