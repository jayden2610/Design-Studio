import { chromium } from "file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs";
import { mkdir } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const directory = path.dirname(fileURLToPath(import.meta.url));
const output = path.join(directory, "output");

await mkdir(output, { recursive: true });
const browser = await chromium.launch({ headless: true });
const pages = [
  ["index.html", "slide-1-cover.png"],
  ["prompt-1.html", "slide-2-prompt-1.png"],
  ["prompt-2.html", "slide-3-prompt-2.png"],
  ["prompt-3.html", "slide-4-prompt-3.png"],
];
for (const [source, target] of pages) {
  const page = await browser.newPage({ viewport: { width: 1080, height: 1350 }, deviceScaleFactor: 1 });
  await page.goto(`file:///${path.join(directory, source).replaceAll("\\", "/")}`, { waitUntil: "networkidle" });
  await page.locator(".page").screenshot({ path: path.join(output, target) });
  await page.close();
}
await browser.close();
