const { chromium } = require('playwright');
const { pathToFileURL } = require('url');
const path = require('path');

const root = 'C:/Users/angdo/Desktop/Carousel Design Studio/Portfolio Concepts';
const concepts = ['Gimbap Roll v2', 'Noodle Signal v2', 'First Crumb v2'];
const wrapper = pathToFileURL(path.join(root, '_working', 'small-logo-wrapper.html')).href;

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 640, height: 640 }, deviceScaleFactor: 1 });
  for (const concept of concepts) {
    const image = pathToFileURL(path.join(root, concept, '01-logo-illustration.png')).href;
    await page.goto(`${wrapper}?src=${encodeURIComponent(image)}`, { waitUntil: 'networkidle' });
    await page.locator('body').screenshot({ path: path.join(root, concept, '02-logo-small.png'), omitBackground: true });
  }
  await browser.close();
})();
