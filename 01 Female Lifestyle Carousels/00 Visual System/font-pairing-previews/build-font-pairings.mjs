import fs from "node:fs/promises";
import path from "node:path";
import { Presentation, PresentationFile } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs";

const outDir = import.meta.dirname;
const photoPath = path.join(import.meta.dirname, "..", "..", "01 Source Assets", "lifestyle-ugc", "03-pack1-portrait-turned.png");
const W = 1080, H = 1350;
const palettes = [
  { name: "Cormorant Garamond + DM Sans", display: "Cormorant Garamond", sans: "DM Sans", bg: "#F8F1E8", ink: "#342E3F", accent: "#B98274", title: "weekend notes", body: "coffee, a few pages, and nowhere urgent to be." },
  { name: "DM Serif Display + DM Sans", display: "DM Serif Display", sans: "DM Sans", bg: "#F4E7E4", ink: "#342E3F", accent: "#9D6A62", title: "little rituals", body: "small things that made the day softer." },
  { name: "Fraunces + Manrope", display: "Fraunces", sans: "Manrope", bg: "#E8EEF0", ink: "#26343A", accent: "#6B8790", title: "currently loving", body: "soft light, open windows, and flowers that make the room feel awake." },
  { name: "Libre Baskerville + Plus Jakarta Sans", display: "Libre Baskerville", sans: "Plus Jakarta Sans", bg: "#EEE8F2", ink: "#3C3046", accent: "#927FA1", title: "a soft reset", body: "rest is part of the plan." },
  { name: "Bodoni Moda + DM Sans", display: "Bodoni Moda", sans: "DM Sans", bg: "#F3EBDD", ink: "#3A3027", accent: "#AF8068", title: "a little life update", body: "a walk, a change of pace, and the feeling of coming back to myself." }
];

function box(slide, geometry, left, top, width, height, fill, line = { style: "solid", fill: "none", width: 0 }, radius) {
  return slide.shapes.add({ geometry, position: { left, top, width, height }, fill, line, ...(radius ? { borderRadius: radius } : {}) });
}
function text(slide, value, left, top, width, height, style) {
  const item = box(slide, "textbox", left, top, width, height, "none");
  item.text = value;
  item.text.style = style;
  return item;
}
async function blob(filename, data) {
  await fs.writeFile(path.join(outDir, filename), new Uint8Array(await data.arrayBuffer()));
}

async function main() {
  const photo = await fs.readFile(photoPath);
  const deck = Presentation.create({ slideSize: { width: W, height: H } });

  for (const [index, pair] of palettes.entries()) {
    const slide = deck.slides.add();
    slide.background.fill = pair.bg;
    text(slide, "WEEKEND PHOTO DIARY", 78, 80, 500, 28, { fontSize: 17, bold: true, color: pair.accent, typeface: pair.sans, tracking: 3 });
    text(slide, pair.title, 78, 190, 520, 220, { fontSize: 96, color: pair.ink, typeface: pair.display, lineSpacing: 0.88 });
    box(slide, "rect", 78, 595, 95, 4, pair.accent);
    text(slide, pair.body, 78, 640, 430, 125, { fontSize: 27, color: pair.ink, typeface: pair.sans, lineSpacing: 1.2 });
    text(slide, `${String(index + 1).padStart(2, "0")}  /  ${pair.name}`, 78, 1190, 700, 28, { fontSize: 16, bold: true, color: pair.accent, typeface: pair.sans, tracking: 1 });
    slide.images.add({ blob: photo, contentType: "image/png", alt: "Woman reading with coffee by a window", fit: "cover", position: { left: 590, top: 230, width: 412, height: 690 }, geometry: "roundRect", borderRadius: "rounded-2xl" });
    box(slide, "roundRect", 660, 1015, 270, 70, "none", { style: "solid", fill: pair.accent, width: 2 }, "rounded-2xl");
    text(slide, "SAVE THIS FEELING", 680, 1038, 230, 24, { fontSize: 16, bold: true, color: pair.accent, typeface: pair.sans, alignment: "center", tracking: 1 });
  }

  for (const [i, slide] of deck.slides.items.entries()) await blob(`option-${i + 1}.png`, await deck.export({ slide, format: "png", scale: 1 }));
  await blob("font-pairings-montage.webp", await deck.export({ format: "webp", montage: true, scale: 1 }));
  const pptx = await PresentationFile.exportPptx(deck); await pptx.save(path.join(outDir, "font-pairings-preview.pptx"));
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
