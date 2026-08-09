const { chromium } = require('playwright');
const path = require('path');

const root = 'C:/Users/angdo/Desktop/Carousel Design Studio/Portfolio Concepts';
const concepts = ['Gimbap Roll v2', 'Noodle Signal v2', 'First Crumb v2'];
const frames = [
  ['03-packaging-application.png', '#packaging'],
  ['04-menu-application.png', '#menu'],
  ['05-signage-application.png', '#signage'],
  ['06-social-launch-01.png', '#social-1'],
  ['07-social-launch-02.png', '#social-2'],
];

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 }, deviceScaleFactor: 1 });
  for (const concept of concepts) {
    const folder = path.join(root, concept);
    const board = path.join(folder, '08-portfolio-board.html');
    await page.goto('file:///' + board.replace(/\\/g, '/'), { waitUntil: 'networkidle' });
    for (const [output, selector] of frames) {
      await page.locator(selector).screenshot({ path: path.join(folder, output) });
    }
  }
  await browser.close();
})();
