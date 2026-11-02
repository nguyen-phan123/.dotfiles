const http = require('http');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const PORT = process.env.PORT || 4321;
const DOTFILES_ROOT = path.resolve(__dirname, '../..');

function getGhosttyConfig() {
  const cfgPath = path.join(DOTFILES_ROOT, 'terminal/ghostty/.config/ghostty/config');
  if (!fs.existsSync(cfgPath)) return { theme: 'default' };
  const content = fs.readFileSync(cfgPath, 'utf8');
  const match = content.match(/^[ \t]*theme[ \t]*=[ \t]*([^\r\n#]+)/m);
  return {
    theme: match ? match[1].trim().replace(/['"]/g, '') : 'default'
  };
}

function getGhosttyThemes() {
  const themesDir = path.join(DOTFILES_ROOT, 'terminal/ghostty/.config/ghostty/themes');
  if (!fs.existsSync(themesDir)) return [];
  const files = fs.readdirSync(themesDir).filter(f => !f.startsWith('.') && f !== 'themes.json');
  return files.map(file => {
    const full = path.join(themesDir, file);
    try {
      const content = fs.readFileSync(full, 'utf8');
      const bgMatch = content.match(/^[ \t]*background[ \t]*=[ \t]*([^\r\n#]+)/m);
      const fgMatch = content.match(/^[ \t]*foreground[ \t]*=[ \t]*([^\r\n#]+)/m);
      return {
        id: file,
        name: file,
        background: bgMatch ? bgMatch[1].trim() : '#1e1e2e',
        foreground: fgMatch ? fgMatch[1].trim() : '#cdd6f4'
      };
    } catch {
      return null;
    }
  }).filter(Boolean);
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);

  if (url.pathname === '/api/status' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    const ghostty = getGhosttyConfig();
    return res.end(JSON.stringify({ ghostty, dotfilesRoot: DOTFILES_ROOT }));
  }

  if (url.pathname === '/api/themes' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify(getGhosttyThemes()));
  }

  if (url.pathname === '/api/theme/apply' && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      try {
        const { theme } = JSON.parse(body || '{}');
        if (!theme) throw new Error('Missing theme name');
        execSync(`bash "${path.join(DOTFILES_ROOT, 'terminal/scripts/ghostty-theme.sh')}" apply "${theme}"`, {
          cwd: DOTFILES_ROOT
        });
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success: true, theme }));
      } catch (err) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: err.message }));
      }
    });
    return;
  }

  if (url.pathname === '/api/sync/antigravity' && req.method === 'POST') {
    try {
      const output = execSync(`node "${path.join(DOTFILES_ROOT, 'shell/zsh/.sync-antigravity.js')}"`, {
        cwd: DOTFILES_ROOT
      }).toString();
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ success: true, output }));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ error: err.message }));
    }
  }

  if (url.pathname === '/' || url.pathname === '/index.html') {
    const htmlPath = path.join(__dirname, 'index.html');
    if (fs.existsSync(htmlPath)) {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      return res.end(fs.readFileSync(htmlPath));
    }
  }

  res.writeHead(404, { 'Content-Type': 'text/plain' });
  res.end('Not Found');
});

server.listen(PORT, () => {
  console.log(`Dotfiles GUI running at http://localhost:${PORT}`);
});

