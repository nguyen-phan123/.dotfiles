const test = require('node:test');
const assert = require('node:assert/strict');
const { execSync } = require('node:child_process');
const path = require('node:path');
const fs = require('node:fs');

const dotfilesRoot = path.resolve(__dirname, '../..');
const themesDir = path.join(dotfilesRoot, 'terminal/ghostty/.config/ghostty/themes');
const scriptPath = path.join(dotfilesRoot, 'terminal/scripts/ghostty-theme.sh');
const downloaderPath = path.join(dotfilesRoot, 'terminal/scripts/download-ghostty-themes.js');

test('ghostty themes directory exists and contains dark themes', () => {
  assert.ok(fs.existsSync(themesDir), 'Themes directory must exist');

  const files = fs.readdirSync(themesDir).filter(f => !f.startsWith('.') && f !== 'themes.json');
  assert.ok(files.length >= 68, `Expected at least 68 themes/aliases, found ${files.length}`);

  // Check some staple dark themes exist
  const stapleThemes = ['catppuccin-mocha', 'dracula-default', 'tokyo-night-default', 'gruvbox-dark', 'nord-default'];
  stapleThemes.forEach(theme => {
    assert.ok(fs.existsSync(path.join(themesDir, theme)), `Theme ${theme} must exist`);
  });
});

test('ghostty-theme.sh script syntax and execution validation', () => {
  assert.ok(fs.existsSync(scriptPath), 'ghostty-theme.sh script must exist');

  // Verify bash syntax
  assert.doesNotThrow(() => {
    execSync(`bash -n "${scriptPath}"`);
  }, 'ghostty-theme.sh syntax is invalid');

  // Test current command
  const currentOutput = execSync(`bash "${scriptPath}" current`, { encoding: 'utf-8' });
  assert.match(currentOutput, /Current Ghostty Theme:/);

  // Test list command
  const listOutput = execSync(`bash "${scriptPath}" list`, { encoding: 'utf-8' });
  assert.match(listOutput, /Installed Ghostty Dark Themes/);
  assert.match(listOutput, /catppuccin-mocha/);

  // Test preview command
  const previewOutput = execSync(`bash "${scriptPath}" preview catppuccin-mocha`, { encoding: 'utf-8' });
  assert.match(previewOutput, /Catppuccin/);
  assert.match(previewOutput, /Background:/);
  assert.match(previewOutput, /Palette 0-7/);
});

test('download-ghostty-themes.js syntax validation', () => {
  assert.ok(fs.existsSync(downloaderPath), 'download-ghostty-themes.js must exist');
  assert.doesNotThrow(() => {
    execSync(`node -c "${downloaderPath}"`);
  }, 'download-ghostty-themes.js syntax is invalid');
});
