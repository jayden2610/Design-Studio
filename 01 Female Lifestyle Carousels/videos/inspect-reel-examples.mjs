import fs from 'node:fs/promises';
import path from 'node:path';
import { chromium } from 'file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs';

const source = 'C:/Users/angdo/Downloads/Telegram Desktop/Reel Example';
const out = path.resolve('videos/reel-example-inspection');
await fs.mkdir(out, { recursive: true });
const files = (await fs.readdir(source)).filter(f => f.endsWith('.mp4')).sort();
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 540, height: 960 }, deviceScaleFactor: 1 });
const results = [];
const inspectionPage = path.resolve('videos/reel-example-inspection/inspection.html');
await fs.writeFile(inspectionPage, '<!doctype html><video id="v" controls></video>', 'utf8');
await page.goto('file:///' + inspectionPage.replaceAll('\\', '/'), { waitUntil: 'load' });

for (const file of files) {
  const url = 'file:///' + source.replaceAll('\\', '/').replaceAll(' ', '%20') + '/' + file;
  const meta = await page.evaluate(url => new Promise(resolve => {
    const v = document.querySelector('#v');
    v.src = url;
    const timeout = setTimeout(() => resolve({ error: 'metadata timeout' }), 15000);
    v.onloadedmetadata = () => resolve({ duration: v.duration, width: v.videoWidth, height: v.videoHeight });
    v.onerror = () => resolve({ error: 'decode failed' });
  }), url);
  const safe = file.replace('.mp4', '');
  const times = meta.duration ? [0, meta.duration * .25, meta.duration * .5, meta.duration * .75, Math.max(0, meta.duration - .08)] : [];
  for (let i = 0; i < times.length; i++) {
    await page.evaluate(t => new Promise(resolve => { const v = document.querySelector('#v'); const timeout = setTimeout(resolve, 5000); v.onseeked = () => { clearTimeout(timeout); resolve(); }; v.currentTime = t; }), times[i]);
    await page.screenshot({ path: path.join(out, `${safe}-${i + 1}.png`) });
  }
  results.push({ file, ...meta, sampledAt: times });
}

await fs.writeFile(path.join(out, 'metadata.json'), JSON.stringify(results, null, 2));
await browser.close();
console.log(JSON.stringify(results, null, 2));
