import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { chromium } from 'file:///C:/Users/angdo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs';

const root = path.dirname(fileURLToPath(import.meta.url));
const content = JSON.parse(await fs.readFile(path.join(root, 'content.json'), 'utf8'));
const browser = await chromium.launch({ headless: true });
const tempDir = path.join(root, 'renders', '.capture');
await fs.mkdir(tempDir, { recursive: true });
const context = await browser.newContext({ viewport: { width: 540, height: 960 }, deviceScaleFactor: 1, recordVideo: { dir: tempDir, size: { width: 540, height: 960 } } });
const page = await context.newPage();
await page.goto(pathToFileURL(path.join(root, 'index.html')).href, { waitUntil: 'load' });

const imageUrls = content.frames.map(frame => pathToFileURL(path.resolve(root, frame.image)).href);
await page.evaluate(({ content, imageUrls }) => {
  window.__reelReady = new Promise(async resolve => {
    const canvas = document.querySelector('#reel');
    const ctx = canvas.getContext('2d');
    const images = await Promise.all(imageUrls.map(src => new Promise((ok, bad) => {
      const img = new Image(); img.onload = () => ok(img); img.onerror = bad; img.src = src;
    })));
    const W = canvas.width, H = canvas.height;
    const wrap = (text, maxChars) => text.split('\n').flatMap(line => {
      const words = line.split(' '), out = []; let current = '';
      for (const word of words) { const candidate = current ? current + ' ' + word : word; if (candidate.length > maxChars && current) { out.push(current); current = word; } else current = candidate; }
      if (current) out.push(current); return out;
    });
    let startTime = null;
    const draw = (now) => {
      if (startTime === null) startTime = now;
      const elapsed = now - startTime;
      const t = Math.min(elapsed / content.durationMs, 0.9999);
      const index = Math.min(content.frames.length - 1, Math.floor(t * content.frames.length));
      const local = (t * content.frames.length) % 1;
      const frame = content.frames[index];
      const img = images[index];
      const ease = x => x < .5 ? 2*x*x : 1 - Math.pow(-2*x+2, 2)/2;
      const enter = ease(Math.min(local / .18, 1));
      const exit = ease(Math.max((local - .82) / .18, 0));
      const opacity = Math.min(enter, 1 - exit * .35);
      ctx.clearRect(0, 0, W, H);
      const scale = Math.max(W / img.width, H / img.height);
      const zoom = 1.04 + local * .035;
      const iw = img.width * scale * zoom, ih = img.height * scale * zoom;
      ctx.save(); ctx.globalAlpha = opacity; ctx.drawImage(img, (W-iw)/2, (H-ih)/2); ctx.restore();
      const gradient = ctx.createLinearGradient(0, 0, 0, H); gradient.addColorStop(0, 'rgba(34,24,28,.22)'); gradient.addColorStop(.42, 'rgba(34,24,28,.03)'); gradient.addColorStop(1, 'rgba(34,24,28,.72)'); ctx.fillStyle = gradient; ctx.fillRect(0,0,W,H);
      ctx.save(); ctx.globalAlpha = opacity; ctx.fillStyle = '#f8f1e8'; ctx.font = '600 28px Arial'; ctx.letterSpacing = '3px'; ctx.fillText(frame.eyebrow.toUpperCase(), 78, 150);
      ctx.font = '700 82px Arial'; ctx.letterSpacing = '-2px'; let y = 580 + (1-enter)*35; for (const line of wrap(frame.title, 16)) { ctx.fillText(line, 78, y); y += 94; }
      ctx.fillStyle = '#f2c3cf'; ctx.font = '400 34px Arial'; y += 38; for (const line of wrap(frame.body, 33)) { ctx.fillText(line, 82, y); y += 49; }
      ctx.fillStyle = '#f8f1e8'; ctx.font = '600 27px Arial'; ctx.fillText(frame.tag, 78, 1770);
      ctx.fillStyle = '#f2c3cf'; ctx.font = '46px Arial'; ctx.fillText(index === 0 ? '✦' : index === 1 ? '→' : index === 2 ? '♡' : '✿', 936, 170);
      ctx.restore();
      if (elapsed < content.durationMs) requestAnimationFrame(draw); else resolve(true);
    };
    requestAnimationFrame(draw);
  });
}, { content, imageUrls });

await page.evaluate(() => window.__reelReady);
const video = page.video();
await context.close();
await fs.mkdir(path.join(root, 'renders'), { recursive: true });
await fs.copyFile(await video.path(), path.join(root, 'renders', 'template-drop-mock.webm'));
await browser.close();
console.log('Rendered videos/01-template-drop/renders/template-drop-mock.webm');
