const { chromium } = require('playwright');
const { pathToFileURL } = require('url');
const path = require('path');

const root = 'C:/Users/angdo/Desktop/Carousel Design Studio/Portfolio Concepts';
const jobs = [
  ['Gimbap Roll', '03-packaging-application.png', '#packaging'],
  ['Gimbap Roll', '04-menu-application.png', '#menu'],
  ['Gimbap Roll', '05-signage-application.png', '#signage'],
  ['Gimbap Roll', '06-social-launch-01.png', '#social-1'],
  ['Gimbap Roll', '07-social-launch-02.png', '#social-2'],
  ['Noodle Signal', '03-packaging-application.png', '#packaging'],
  ['Noodle Signal', '04-menu-application.png', '#menu'],
  ['Noodle Signal', '05-signage-application.png', '#signage'],
  ['Noodle Signal', '06-social-launch-01.png', '#social-1'],
  ['Noodle Signal', '07-social-launch-02.png', '#social-2'],
  ['First Crumb', '03-packaging-application.png', '#packaging'],
  ['First Crumb', '04-menu-application.png', '#menu'],
  ['First Crumb', '05-signage-application.png', '#signage'],
  ['First Crumb', '06-social-launch-01.png', '#social-1'],
  ['First Crumb', '07-social-launch-02.png', '#social-2'],
];

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1200, height: 900 }, deviceScaleFactor: 1 });
  for (const [concept, output, selector] of jobs) {
    const folder = path.join(root, concept);
    await page.goto(pathToFileURL(path.join(folder, '08-portfolio-board.html')).href, { waitUntil: 'networkidle' });
    await page.locator(selector).screenshot({ path: path.join(folder, output) });
  }
  await browser.close();
})();
