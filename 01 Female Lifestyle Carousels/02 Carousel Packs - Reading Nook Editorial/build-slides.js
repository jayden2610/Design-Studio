const fs = require('fs');
const path = require('path');

// Real stickers cropped from Jayden's own "Soft iOS Sticker Library" Canva
// file (the pack he sells alongside this template) — see stickers/*.png.
// aspect = height/width, used to size each <img> proportionally.
const STICKERS = {
  'tape-strip': 88 / 163,
  'flower-bouquet': 148 / 100,
  'coffee-cup': 115 / 152,
  'book-stack': 95 / 132,
  'dried-flowers': 184 / 110,
  'journal-pen': 170 / 106,
  'paperclip': 128 / 131,
};

const slides = [
  {
    n: 1, file: '01-pack1-hero.png',
    scrim: 'top', block: 'top left',
    caption: 'SUNDAY RESET · OCT', headline: ['slow', 'mornings'], script: 'coffee, quiet &amp; a good book',
    tape: { top: 56, left: 620, rot: -7, width: 160 },
    sticker: { name: 'flower-bouquet', top: 140, left: 700, rot: 8, width: 92 },
  },
  {
    n: 2, file: '02-pack1-establishing.png',
    scrim: 'bottom', block: 'bottom left',
    caption: '8:32 AM', headline: ['my corner', 'of quiet'], script: 'just me and my little rituals',
    tape: { top: 50, left: 56, rot: -6, width: 160 },
    sticker: { name: 'coffee-cup', bottom: 470, left: 800, rot: -8, width: 100 },
  },
  {
    n: 3, file: '03-pack1-portrait-turned.png',
    scrim: 'top', block: 'top right',
    caption: 'CURRENTLY READING', headline: ['one page', 'at a time'], script: 'no rush, no agenda',
    tape: { top: 54, right: 580, rot: 6, width: 160 },
    sticker: { name: 'book-stack', top: 404, right: 66, rot: -10, width: 108 },
  },
  {
    n: 4, file: '04-pack1-coffee-hands.png',
    scrim: 'top', block: 'top left',
    caption: "COFFEE O'CLOCK", headline: ['warm hands,', 'warm heart'], script: 'the little things',
    tape: { top: 50, left: 600, rot: -8, width: 160 },
    sticker: { name: 'dried-flowers', top: 160, left: 690, rot: 9, width: 84 },
  },
  {
    n: 5, file: '05-pack1-filler-journal.png',
    scrim: 'bottom', block: 'bottom left',
    caption: 'PAGE 12', headline: ['dear', 'journal,'], script: 'today felt like enough',
    tape: { bottom: 330, left: 56, rot: -5, width: 160 },
    sticker: { name: 'journal-pen', bottom: 286, left: 546, rot: 10, width: 88 },
  },
  {
    n: 6, file: '28-pack1-filler-windowlight.png',
    scrim: 'top', block: 'top right',
    caption: 'SLOW LIVING · CH. 2', headline: ['golden hour', 'thoughts'], script: 'still here, still soft',
    tape: { top: 52, right: 600, rot: 7, width: 160 },
    sticker: { name: 'paperclip', top: 406, right: 66, rot: -9, width: 100 },
  },
];

function posStyle(obj, keys) {
  return keys.filter(k => obj[k] !== undefined).map(k => `${k}: ${obj[k]}px;`).join(' ');
}

function render(s) {
  const [blockV, blockH] = s.block.split(' ');
  const tapeStyle = posStyle(s.tape, ['top', 'bottom', 'left', 'right']) +
    ` width:${s.tape.width}px; height:${Math.round(s.tape.width * STICKERS['tape-strip'])}px; transform: rotate(${s.tape.rot}deg);`;
  const st = s.sticker;
  const stickerStyle = posStyle(st, ['top', 'bottom', 'left', 'right']) +
    ` width:${st.width}px; height:${Math.round(st.width * STICKERS[st.name])}px; transform: rotate(${st.rot}deg);`;
  return `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="../assets/styles.css">
</head>
<body>
<div class="slide">
  <img class="bg" src="../images/${s.file}" alt="">
  <div class="scrim scrim--${s.scrim}"></div>
  <img class="real-sticker tape" src="../stickers/tape-strip.png" style="${tapeStyle}" alt="">
  <img class="real-sticker" src="../stickers/${st.name}.png" style="${stickerStyle}" alt="">
  <div class="text-block text-block--${blockV} text-block--${blockH}">
    <div class="caption">${s.caption}</div>
    <h1 class="headline">${s.headline.join('<br>')}</h1>
    <p class="script">${s.script}</p>
  </div>
  <div class="counter">0${s.n} / 06</div>
</div>
</body>
</html>`;
}

const outDir = path.join(__dirname, 'slides');
fs.mkdirSync(outDir, { recursive: true });
for (const s of slides) {
  fs.writeFileSync(path.join(outDir, `slide-${s.n}.html`), render(s));
}
console.log('Built', slides.length, 'slides');
