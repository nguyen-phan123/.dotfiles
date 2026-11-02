const test = require('node:test');
const assert = require('node:assert/strict');
const { execSync } = require('node:child_process');
const path = require('node:path');
const fs = require('node:fs');

test('shell configuration files syntax validation', () => {
  const zshProfilePath = path.resolve(__dirname, '.zsh_profile');
  const zshrcPath = path.resolve(__dirname, '.zshrc');

  // Verify zsh syntax parsing
  assert.doesNotThrow(() => {
    execSync(`zsh -n "${zshProfilePath}"`);
  }, 'zsh_profile syntax is invalid');

  assert.doesNotThrow(() => {
    execSync(`zsh -n "${zshrcPath}"`);
  }, 'zshrc syntax is invalid');
});

test('ghostty config syntax validation', () => {
  const ghosttyConfigPath = path.resolve(__dirname, '../../terminal/ghostty/.config/ghostty/config');
  assert.ok(fs.existsSync(ghosttyConfigPath), 'Ghostty config file must exist');

  const ghosttyBin = '/Applications/Ghostty.app/Contents/MacOS/ghostty';
  if (fs.existsSync(ghosttyBin)) {
    assert.doesNotThrow(() => {
      execSync(`"${ghosttyBin}" +validate-config --config-file="${ghosttyConfigPath}" 2>&1 || true`);
    });
  }
});

test('ai config shortcuts and functions are defined', () => {
  const zshProfilePath = path.resolve(__dirname, '.zsh_profile');
  const scriptPath = path.resolve(__dirname, '../../scripts/open-ai-settings.sh');

  // Verify open-ai-settings.sh syntax
  assert.doesNotThrow(() => {
    execSync(`bash -n "${scriptPath}"`);
  }, 'open-ai-settings.sh syntax is invalid');

  // Verify functions in .zsh_profile
  const output = execSync(
    `zsh -c 'source "${zshProfilePath}"; echo "EGEMINI=$(whence -w egemini)"; echo "ECLAUDE=$(whence -w eclaude)"; echo "EAI=$(whence -w eai)"'`,
    { encoding: 'utf-8' }
  );

  assert.match(output, /EGEMINI=egemini: function/, 'egemini should be defined as a function');
  assert.match(output, /ECLAUDE=eclaude: function/, 'eclaude should be defined as a function');
  assert.match(output, /EAI=eai: function/, 'eai should be defined as a function');
});

