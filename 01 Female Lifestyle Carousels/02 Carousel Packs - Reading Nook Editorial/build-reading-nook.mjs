import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { chromium } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs";

const systemRoot = path.dirname(fileURLToPath(import.meta.url));
const packName = process.argv[2];
if (!packName) throw new Error("Usage: node build-reading-nook.mjs <pack-folder>");
const packRoot = path.join(systemRoot, packName);
const content = JSON.parse(await fs.readFile(path.join(packRoot, "content.json"), "utf8"));
const outputDir = path.join(packRoot, "output");
const htmlDir = path.join(outputDir, "html");
await fs.mkdir(htmlDir, { recursive: true });

const esc = (value = "") => String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;");
const image = (src, className = "hero") => `<img class="${className}" src="${pathToFileURL(path.resolve(packRoot, src)).href}" alt="">`;
const title = (value) => esc(value).replaceAll("\n", "<br>");
const css = `*{box-sizing:border-box}html,body{margin:0;width:1080px;height:1350px;overflow:hidden}body{font-family:'Manrope',Arial,sans-serif;color:#342e3f}.slide{position:relative;width:1080px;height:1350px;overflow:hidden;background:#fbf3e6}.hero{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}.wash{position:absolute;inset:0;background:linear-gradient(180deg,rgba(251,243,230,.76),rgba(251,243,230,.04) 49%,rgba(52,46,63,.48))}.eyebrow{position:absolute;z-index:2;top:68px;left:72px;font-size:17px;font-weight:700;letter-spacing:2.6px;color:#9ca274}.title{position:absolute;z-index:2;left:68px;top:120px;width:700px;margin:0;font:700 92px/.86 'Fraunces',Georgia,serif;letter-spacing:-4px;color:#342e3f}.body{position:absolute;z-index:2;left:72px;bottom:118px;max-width:530px;margin:0;color:#fffaf4;font-size:25px;line-height:1.28}.meta{position:absolute;z-index:2;left:72px;bottom:68px;color:#fffaf4;font-size:16px;font-weight:700;letter-spacing:1.8px}.counter{position:absolute;z-index:2;right:72px;bottom:60px;width:60px;height:60px;border-radius:50%;display:grid;place-items:center;background:#fbf3e6;color:#342e3f;font-weight:700}.card{position:absolute;z-index:2;left:72px;right:72px;bottom:78px;padding:30px 34px;background:rgba(251,243,230,.93);border-radius:24px}.card .body{position:static;color:#342e3f;max-width:600px}.card .meta{position:static;margin:18px 0 0;color:#9ca274}.cover .title{color:#342e3f}.cover .body,.cover .meta{color:#342e3f}.cover .wash{background:linear-gradient(180deg,rgba(251,243,230,.88),rgba(251,243,230,.12) 62%,rgba(251,243,230,.48))}.collage{padding:66px}.collage .title,.list .title{top:100px}.grid{position:absolute;z-index:2;left:66px;right:66px;bottom:70px;display:grid;grid-template-columns:1fr 1fr;gap:18px}.grid img{width:100%;height:330px;object-fit:cover;border-radius:22px}.list .hero{object-position:center}.list .wash{background:linear-gradient(180deg,rgba(251,243,230,.86),rgba(251,243,230,.38) 60%,rgba(52,46,63,.5))}.listbox{position:absolute;z-index:2;left:72px;top:475px;width:470px;padding:26px 30px;border-radius:22px;background:rgba(251,243,230,.92)}.listbox p{margin:12px 0;font:600 28px/1.15 'Fraunces',Georgia,serif}.accent{color:#9ca274}`;
const overrides = `.title{font-family:'Fraunces',Georgia,'Times New Roman',serif;font-size:88px;line-height:.93;letter-spacing:-1.8px;text-shadow:0 1px 0 rgba(255,255,255,.25)}.eyebrow{padding:8px 12px;border-radius:999px;background:rgba(251,243,230,.78);color:#65703d}.card{border:1px solid rgba(52,46,63,.12);box-shadow:0 12px 34px rgba(52,46,63,.12)}.card .body{font-family:'Fraunces',Georgia,serif;font-size:27px;line-height:1.15}.cover .card{left:72px;right:auto;width:760px;padding:26px 30px}.cover .card-4{width:860px}.cover .card .meta{margin-top:14px}.collage .title{top:112px;width:680px}.collage .grid{top:400px;bottom:70px;grid-template-rows:1fr 1fr;gap:22px}.collage .grid img{height:100%;min-height:0;box-shadow:0 10px 28px rgba(52,46,63,.12)}.listbox{box-shadow:0 10px 28px rgba(52,46,63,.14);border:1px solid rgba(52,46,63,.12)}`;
function markup(slide, index) {
  const head = `<div class="eyebrow">${esc(slide.eyebrow)}</div><h1 class="title">${title(slide.title)}</h1><div class="counter">0${index + 1}</div>`;
  if (slide.kind === "collage") return `<section class="slide collage"><div class="eyebrow">${esc(slide.eyebrow)}</div><h1 class="title">${title(slide.title)}</h1><div class="grid">${slide.photos.map(photo => image(photo, "grid-photo")).join("")}</div><div class="counter">0${index + 1}</div></section>`;
  if (slide.kind === "list") return `<section class="slide list">${image(slide.hero)}<div class="wash"></div>${head}<div class="listbox">${slide.items.map(item => `<p><span class="accent">→</span> ${esc(item)}</p>`).join("")}</div><p class="meta">${esc(slide.meta)}</p></section>`;
  return `<section class="slide cover">${image(slide.hero)}<div class="wash"></div>${head}<div class="card card-${index + 1}"><p class="body">${esc(slide.body)}</p><p class="meta">${esc(slide.meta)}</p></div></section>`;
}
const browser = await chromium.launch({ headless: true });
for (const [index, slide] of content.slides.entries()) {
  const html = `<!doctype html><html><head><meta charset="utf-8"><style>${css}${overrides}</style></head><body>${markup(slide, index)}</body></html>`;
  const htmlPath = path.join(htmlDir, `slide-${index + 1}.html`);
  await fs.writeFile(htmlPath, html, "utf8");
  const page = await browser.newPage({ viewport: { width: 1080, height: 1350 }, deviceScaleFactor: 1 });
  await page.goto(pathToFileURL(htmlPath).href, { waitUntil: "networkidle" });
  await page.screenshot({ path: path.join(outputDir, `slide-${index + 1}.png`), type: "png" });
  await page.close();
}
await browser.close();
console.log(`Rendered ${content.slides.length} Reading Nook slides for ${packName}`);
