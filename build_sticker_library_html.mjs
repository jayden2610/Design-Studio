import { readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

const root = 'C:/Users/angdo/Desktop/Carousel Design Studio/01 Female Lifestyle Carousels/03 Sticker Pack';
const additionDir = path.join(root, '04 iOS Photo Diary Additions');
const original = (await readdir(root)).filter((f) => f.endsWith('.png')).sort();
const additions = (await readdir(additionDir)).filter((f) => f.endsWith('.png')).sort();
const groups = [
  ['Lifestyle objects 01', original.slice(0, 15), '.'],
  ['Lifestyle objects 02', original.slice(15), '.'],
  ['Soft mobile UI', additions.slice(0, 16), './04 iOS Photo Diary Additions'],
  ['Photo-diary tools', additions.slice(16, 28), './04 iOS Photo Diary Additions'],
  ['Lifestyle additions', additions.slice(28), './04 iOS Photo Diary Additions'],
];
const label = (name) => name.replace(/^\d+-/, '').replace(/-outlined\.png$/, '').replace(/\.png$/, '').replaceAll('-', ' ');
const card = (name, base) => `<div class="card"><div class="art"><img src="${base}/${name}"/></div><span>${label(name)}</span></div>`;
const pages = groups.map(([title, files, base], page) => `<div data-document-role="page" data-label="Sticker Library - ${title}" class="page"><div class="top"><div><p>SOFT IOS PHOTO-DIARY</p><h1>${title}</h1></div><b>${String(page + 1).padStart(2, '0')} / 05</b></div><div class="grid">${files.map((file) => card(file, base)).join('')}</div><div class="footer">70 draggable stickers · female lifestyle creator kit</div></div>`).join('');
const css = `*{box-sizing:border-box}body{margin:0;background:#eee;font-family:Arial,sans-serif}.page{width:1080px;height:1350px;position:relative;overflow:hidden;padding:72px;background:#f7edf0;color:#4f3741;page-break-after:always}.page:nth-child(2){background:#f9f0e6}.page:nth-child(3){background:#ebe8f4}.page:nth-child(4){background:#f3e9e5}.page:nth-child(5){background:#eef1e6}.top{display:flex;justify-content:space-between;align-items:start;border-bottom:3px solid #aa7167;padding-bottom:30px}.top p{margin:0 0 10px;font-weight:bold;letter-spacing:4px;font-size:19px}.top h1{font-family:Georgia,serif;font-size:62px;margin:0;letter-spacing:-2px}.top b{font-size:20px;letter-spacing:2px}.grid{margin-top:38px;display:grid;grid-template-columns:repeat(4,1fr);gap:22px}.card{height:220px;padding:12px;border:2px solid #aa7167;border-radius:25px;background:#fffaf7;display:flex;flex-direction:column;justify-content:space-between;box-shadow:0 7px 0 #aa716730}.art{height:160px;display:flex;align-items:center;justify-content:center}.art img{width:155px;height:155px;object-fit:contain}.card span{text-transform:capitalize;font-weight:bold;font-size:15px;line-height:1.15}.footer{position:absolute;bottom:55px;left:72px;font-size:17px;letter-spacing:1px;color:#8d625d}`;
const html = `<!doctype html><html><head><meta charset="utf-8"><style>${css}</style></head><body>${pages}</body></html>`;
const output = path.join(root, 'canva-sticker-library.html');
await writeFile(output, html, 'utf8');
console.log(output);
