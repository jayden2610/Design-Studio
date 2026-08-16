import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { chromium } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs";
import sharp from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp/lib/index.js";

const root = path.dirname(fileURLToPath(import.meta.url));
const content = JSON.parse(await fs.readFile(path.join(root, "content.json"), "utf8"));
const template = await fs.readFile(path.join(root, "template.html"), "utf8");
const outputDir = path.join(root, "output");
const htmlDir = path.join(outputDir, "html");
await fs.mkdir(htmlDir, { recursive: true });
const stylesHref = pathToFileURL(path.join(root, "styles.css")).href;

const esc = (value = "") => String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;");
const image = (src, className) => `<img class="photo ${className}" src="${pathToFileURL(path.resolve(root, src)).href}" alt="">`;
const base = (slide, extra = "") => `<section class="slide ${slide.kind} ${slide.kind === "moments" ? "blue" : slide.kind === "notes" ? "blush" : slide.kind === "collage" ? "lilac" : "paper"}"><div class="eyebrow">${esc(slide.eyebrow)}</div><div class="${extra}">`;

function markup(slide) {
  if (slide.kind === "cover") return `${base(slide)}<h1 class="title">${esc(slide.title)}</h1><div class="rule"></div><p class="body">${esc(slide.body)}</p><p class="prompt">${esc(slide.prompt)}</p><p class="meta">${esc(slide.meta)}</p>${image(slide.hero, "hero mat")}<div class="scribble"></div></section>`;
  if (slide.kind === "moments") return `${base(slide)}<h1 class="title">${esc(slide.title)}</h1><p class="body">${esc(slide.body)}</p>${image(slide.photos[0], "photo-one rounded")}${image(slide.photos[1], "photo-two rounded")}<div class="accent"></div><div class="note-card"><div class="note-label">A LITTLE NOTE</div><div class="note-quote">${esc(slide.note)}</div></div></section>`;
  if (slide.kind === "notes") return `${base(slide)}<h1 class="title">${esc(slide.title)}</h1><div class="note-card"><div class="note-label">THIS WEEKEND:</div>${slide.notes.map((note) => `<div class="note-row">${esc(note)}</div>`).join("")}</div>${image(slide.photo, "note-photo")}<div class="tag">${esc(slide.tag)}</div></section>`;
  if (slide.kind === "collage") return `${base(slide)}<h1 class="title">${esc(slide.title)}</h1>${image(slide.photos[0], "collage-photo photo-one")}${image(slide.photos[1], "collage-photo photo-two")}${image(slide.photos[2], "collage-photo photo-three")}${image(slide.photos[3], "collage-photo photo-four")}<div class="accent"></div><div class="meta">${esc(slide.meta)}</div></section>`;
  return `${base(slide)}<h1 class="title">${esc(slide.title)}</h1><p class="body">${esc(slide.body)}</p><div class="tag">${esc(slide.tag)}</div>${image(slide.photo, "rounded") }<p class="meta">${esc(slide.meta)}</p><div class="scribble"></div></section>`;
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: content.width, height: content.height }, deviceScaleFactor: 1 });
const slidePaths = [];
for (const [index, slide] of content.slides.entries()) {
  const html = template.replace("{{STYLES}}", stylesHref).replace("{{SLIDE}}", markup(slide));
  const htmlPath = path.join(htmlDir, `slide-${index + 1}.html`);
  await fs.writeFile(htmlPath, html, "utf8");
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.screenshot({ path: path.join(outputDir, `slide-${index + 1}.png`), type: "png" });
  slidePaths.push(path.join(outputDir, `slide-${index + 1}.png`));
}
await browser.close();

const images = await Promise.all(slidePaths.map(async (file) => ({ input: await sharp(file).resize({ width: 216, height: 270 }).png().toBuffer() })));
const montage = sharp({ create: { width: 5 * 216, height: 270, channels: 4, background: "#d7d1cb" } });
await montage.composite(images.map((item, index) => ({ ...item, left: index * 216, top: 0 }))).webp().toFile(path.join(outputDir, "montage.webp"));
console.log(`Rendered ${content.slides.length} slides to ${outputDir}`);
