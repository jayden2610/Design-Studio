const http = require('http');
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname);
const port = 8080;
const contentTypes = {
  '.css': 'text/css; charset=utf-8',
  '.gif': 'image/gif',
  '.html': 'text/html; charset=utf-8',
  '.jpeg': 'image/jpeg',
  '.jpg': 'image/jpeg',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
};

http.createServer((request, response) => {
  const requested = decodeURIComponent((request.url || '/').split('?')[0]);
  const target = path.resolve(root, `.${requested === '/' ? '/index.html' : requested}`);
  if (target !== root && !target.startsWith(`${root}${path.sep}`)) {
    response.writeHead(403);
    return response.end('Forbidden');
  }
  fs.stat(target, (statError, stats) => {
    if (statError || !stats.isFile()) {
      response.writeHead(404);
      return response.end('Not found');
    }
    response.writeHead(200, { 'Content-Type': contentTypes[path.extname(target).toLowerCase()] || 'application/octet-stream' });
    fs.createReadStream(target).pipe(response);
  });
}).listen(port, '0.0.0.0', () => console.log(`Portfolio available on port ${port}`));
