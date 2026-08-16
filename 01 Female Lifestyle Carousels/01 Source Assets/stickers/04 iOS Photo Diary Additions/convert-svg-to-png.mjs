import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const folder = path.dirname(fileURLToPath(import.meta.url));
const files = (await readdir(folder)).filter((file) => file.endsWith('.svg'));

for (const file of files) {
  const source = await readFile(path.join(folder, file));
  await sharp(source, { density: 288 })
    .resize(1254, 1254, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toFile(path.join(folder, file.replace(/\.svg$/i, '.png')));
}

console.log(`Converted ${files.length} SVG stickers to transparent PNG.`);
