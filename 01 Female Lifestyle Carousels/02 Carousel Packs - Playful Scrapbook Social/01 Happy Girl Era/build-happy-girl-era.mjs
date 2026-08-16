import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { chromium } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs";

const root = path.dirname(fileURLToPath(import.meta.url));
const content = JSON.parse(await fs.readFile(path.join(root, "content.json"), "utf8"));
const template = await fs.readFile(path.join(root, "template.html"), "utf8");
const outputDir = path.join(root, "output");
const htmlDir = path.join(outputDir, "html");
await fs.mkdir(htmlDir, { recursive: true });
const stylesHref = pathToFileURL(path.join(root, "styles.css")).href;
const esc = (value = "") => String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;");
const image = (relative) => pathToFileURL(path.resolve(root, relative)).href;
const stickerCluster = `<div class="sticker heart">♥</div><div class="sticker flower">✿</div><div class="sticker sparkle-one">✦</div><div class="sticker sparkle-two">✦</div>`;

function makeSlide(slide) {
  const title = esc(slide.title).replaceAll("\n", "<br>");
  const base = `<img class="hero-full" src="${image(slide.hero)}" alt=""><div class="photo-wash"></div><div class="scribble"></div><div class="eyebrow">${esc(slide.eyebrow)}</div><h1 class="title">${title}</h1>`;
  if (slide.kind === "labels") {
    return `<section class="slide labels">${base}<div class="label-stack">${slide.labels.map((label, i) => `<span class="label label-${i + 1}">${esc(label)}</span>`).join("")}</div>${stickerCluster}<div class="meta">little life update · 02</div></section>`;
  }
  if (slide.kind === "polaroids") {
    return `<section class="slide polaroids">${base}<div class="polaroid-card card-one"><img src="${image(slide.photos[0])}" alt=""><span>just because</span></div><div class="polaroid-card card-two"><img src="${image(slide.photos[1])}" alt=""><span>stop + smell them</span></div>${stickerCluster}<div class="meta">camera roll note · 03</div></section>`;
  }
  if (slide.kind === "currently") {
    return `<section class="slide currently">${base}<div class="checklist">${slide.items.map(item => `<p>♡ ${esc(item)}</p>`).join("")}</div>${stickerCluster}<div class="meta">currently, softly</div></section>`;
  }
  return `<section class="slide hero">${base}<p class="body">${esc(slide.body)}</p><div class="tape one"></div><div class="accent-card">${esc(slide.accent)}</div><figure class="mini-polaroid"><img src="${image(slide.hero)}" alt=""><figcaption>sunny little moment</figcaption></figure>${stickerCluster}<div class="meta">${esc(slide.meta)}</div></section>`;
}

const browser = await chromium.launch({ headless: true });
for (const [index, slide] of content.slides.entries()) {
  const html = template.replace("{{STYLES}}", stylesHref).replace("{{SLIDE}}", makeSlide(slide));
  const number = index + 1;
  const htmlPath = path.join(htmlDir, `slide-${number}.html`);
  await fs.writeFile(htmlPath, html, "utf8");
  const page = await browser.newPage({ viewport: { width: content.width, height: content.height }, deviceScaleFactor: 1 });
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.screenshot({ path: path.join(outputDir, `slide-${number}.png`), type: "png" });
  await page.close();
}
await browser.close();
console.log(`Rendered ${content.slides.length} slides to ${outputDir}`);
