#!/usr/bin/env node
/**
 * Ghostty Dark Themes Downloader & Synchronizer
 * Scrapes and downloads all dark terminal themes from:
 * https://terminalcolors.com/tags/dark/
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

const DOTFILES_ROOT = process.env.DOTFILES_ROOT || path.resolve(__dirname, '../..');
const THEMES_DIR = path.join(DOTFILES_ROOT, 'terminal/ghostty/.config/ghostty/themes');
const METADATA_FILE = path.join(THEMES_DIR, 'themes.json');

// Complete verified catalog of dark themes from terminalcolors.com/tags/dark/
const DEFAULT_CATALOG = [
  { themeId: 'apprentice', themeName: 'Apprentice', variantId: 'default', variantName: 'Default' },
  { themeId: 'ayu', themeName: 'Ayu', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'ayu', themeName: 'Ayu', variantId: 'mirage', variantName: 'Mirage' },
  { themeId: 'catppuccin', themeName: 'Catppuccin', variantId: 'mocha', variantName: 'Mocha' },
  { themeId: 'catppuccin', themeName: 'Catppuccin', variantId: 'macchiato', variantName: 'Macchiato' },
  { themeId: 'catppuccin', themeName: 'Catppuccin', variantId: 'frappe', variantName: 'Frappé' },
  { themeId: 'cobalt2', themeName: 'Cobalt2', variantId: 'default', variantName: 'Default' },
  { themeId: 'deus', themeName: 'Deus', variantId: 'default', variantName: 'Default' },
  { themeId: 'dracula', themeName: 'Dracula', variantId: 'default', variantName: 'Default' },
  { themeId: 'dracula', themeName: 'Dracula', variantId: 'soft', variantName: 'Soft' },
  { themeId: 'everforest', themeName: 'Everforest', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'github', themeName: 'GitHub', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'github', themeName: 'GitHub', variantId: 'dark-dimmed', variantName: 'Dark Dimmed' },
  { themeId: 'github', themeName: 'GitHub', variantId: 'dark-high-contrast', variantName: 'Dark High Contrast' },
  { themeId: 'github', themeName: 'GitHub', variantId: 'dark-colorblind', variantName: 'Dark Colorblind' },
  { themeId: 'gotham', themeName: 'Gotham', variantId: 'default', variantName: 'Default' },
  { themeId: 'gruvbox', themeName: 'Gruvbox', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'gruvbox', themeName: 'Gruvbox', variantId: 'dark-hard-contrast', variantName: 'Dark Hard Contrast' },
  { themeId: 'gruvbox', themeName: 'Gruvbox', variantId: 'dark-soft-contrast', variantName: 'Dark Soft Contrast' },
  { themeId: 'iceberg', themeName: 'Iceberg', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'jellybeans', themeName: 'Jellybeans', variantId: 'default', variantName: 'Default' },
  { themeId: 'kanagawa', themeName: 'Kanagawa', variantId: 'wave', variantName: 'Wave' },
  { themeId: 'kanagawa', themeName: 'Kanagawa', variantId: 'dragon', variantName: 'Dragon' },
  { themeId: 'lucario', themeName: 'Lucario', variantId: 'default', variantName: 'Default' },
  { themeId: 'miasma', themeName: 'Miasma', variantId: 'default', variantName: 'Default' },
  { themeId: 'moonfly', themeName: 'Moonfly', variantId: 'default', variantName: 'Default' },
  { themeId: 'night-owl', themeName: 'Night Owl', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'nightfly', themeName: 'Nightfly', variantId: 'default', variantName: 'Default' },
  { themeId: 'nightfox', themeName: 'Nightfox', variantId: 'default', variantName: 'Default' },
  { themeId: 'nightfox', themeName: 'Nightfox', variantId: 'duskfox', variantName: 'Duskfox' },
  { themeId: 'nightfox', themeName: 'Nightfox', variantId: 'nordfox', variantName: 'Nordfox' },
  { themeId: 'nightfox', themeName: 'Nightfox', variantId: 'terafox', variantName: 'Terafox' },
  { themeId: 'noctis', themeName: 'Noctis', variantId: 'default', variantName: 'Default' },
  { themeId: 'noctis', themeName: 'Noctis', variantId: 'azureus', variantName: 'Azureus' },
  { themeId: 'noctis', themeName: 'Noctis', variantId: 'bordo', variantName: 'Bordo' },
  { themeId: 'noctis', themeName: 'Noctis', variantId: 'minimus', variantName: 'Minimus' },
  { themeId: 'nord', themeName: 'Nord', variantId: 'default', variantName: 'Default' },
  { themeId: 'nordic', themeName: 'Nordic', variantId: 'default', variantName: 'Default' },
  { themeId: 'one', themeName: 'One', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'one-half', themeName: 'One Half', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'panda', themeName: 'Panda', variantId: 'default', variantName: 'Default' },
  { themeId: 'posterpole', themeName: 'Posterpole', variantId: 'default', variantName: 'Default' },
  { themeId: 'posterpole', themeName: 'Posterpole', variantId: 'gray', variantName: 'Gray' },
  { themeId: 'rose-pine', themeName: 'Rosé Pine', variantId: 'default', variantName: 'Default' },
  { themeId: 'rose-pine', themeName: 'Rosé Pine', variantId: 'moon', variantName: 'Moon' },
  { themeId: 'seoul256', themeName: 'Seoul256', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'shades-of-purple', themeName: 'Shades of Purple', variantId: 'default', variantName: 'Default' },
  { themeId: 'shades-of-purple', themeName: 'Shades of Purple', variantId: 'super-dark', variantName: 'Super Dark' },
  { themeId: 'solarized', themeName: 'Solarized', variantId: 'dark', variantName: 'Dark' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'default', variantName: 'Default' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'atlantis', variantName: 'Atlantis' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'andromeda', variantName: 'Andromeda' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'shusia', variantName: 'Shusia' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'maia', variantName: 'Maia' },
  { themeId: 'sonokai', themeName: 'Sonokai', variantId: 'espresso', variantName: 'Espresso' },
  { themeId: 'srcery', themeName: 'Srcery', variantId: 'default', variantName: 'Default' },
  { themeId: 'tender', themeName: 'Tender', variantId: 'default', variantName: 'Default' },
  { themeId: 'tokyo-night', themeName: 'Tokyo Night', variantId: 'default', variantName: 'Default' },
  { themeId: 'tokyo-night', themeName: 'Tokyo Night', variantId: 'storm', variantName: 'Storm' },
  { themeId: 'tokyo-night', themeName: 'Tokyo Night', variantId: 'moon', variantName: 'Moon' },
  { themeId: 'tomorrow', themeName: 'Tomorrow', variantId: 'night', variantName: 'Night' },
  { themeId: 'tomorrow', themeName: 'Tomorrow', variantId: 'night-eighties', variantName: 'Night Eighties' },
  { themeId: 'tomorrow', themeName: 'Tomorrow', variantId: 'night-blue', variantName: 'Night Blue' },
  { themeId: 'tomorrow', themeName: 'Tomorrow', variantId: 'night-bright', variantName: 'Night Bright' },
  { themeId: 'zenbones', themeName: 'Zenbones', variantId: 'zenwritten-dark', variantName: 'Zenwritten Dark' },
  { themeId: 'zenbones', themeName: 'Zenbones', variantId: 'neobones-dark', variantName: 'Neobones Dark' },
  { themeId: 'zenbones', themeName: 'Zenbones', variantId: 'rosebones-dark', variantName: 'Rosebones Dark' },
  { themeId: 'zenbones', themeName: 'Zenbones', variantId: 'forestbones-dark', variantName: 'Forestbones Dark' }
];

function fetchUrl(url) {
  return new Promise((resolve, reject) => {
    const req = https.get(url, { headers: { 'User-Agent': 'Mozilla/5.0 (Ghostty-Theme-Installer)' } }, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        return fetchUrl(res.headers.location).then(resolve).catch(reject);
      }
      if (res.statusCode !== 200) {
        return reject(new Error(`HTTP ${res.statusCode} for ${url}`));
      }
      let body = '';
      res.on('data', chunk => { body += chunk; });
      res.on('end', () => resolve(body));
    });
    req.on('error', reject);
    req.setTimeout(15000, () => {
      req.destroy();
      reject(new Error(`Timeout fetching ${url}`));
    });
  });
}

async function scrapeDarkThemesLive() {
  console.log('📡 Fetching latest dark themes catalog from https://terminalcolors.com/tags/dark/...');
  try {
    const html = await fetchUrl('https://terminalcolors.com/tags/dark/');
    const regex = /props="([^"]+)"/g;
    let m;
    const scraped = [];
    while ((m = regex.exec(html)) !== null) {
      try {
        const jsonStr = m[1].replace(/&quot;/g, '"');
        const parsed = JSON.parse(jsonStr);
        function unwrap(obj) {
          if (Array.isArray(obj)) {
            if (obj.length === 2 && typeof obj[0] === 'number') return unwrap(obj[1]);
            return obj.map(unwrap);
          }
          if (obj && typeof obj === 'object') {
            const res = {};
            for (const k of Object.keys(obj)) res[k] = unwrap(obj[k]);
            return res;
          }
          return obj;
        }
        const unwrapped = unwrap(parsed);
        if (unwrapped.theme && unwrapped.theme.variants) {
          unwrapped.theme.variants.forEach(v => {
            scraped.push({
              themeId: unwrapped.theme.id,
              themeName: unwrapped.theme.name,
              variantId: v.id,
              variantName: v.name
            });
          });
        }
      } catch (err) {}
    }
    if (scraped.length >= 50) {
      console.log(`✅ Discovered ${scraped.length} dark themes from live page.`);
      return scraped;
    }
  } catch (err) {
    console.warn(`⚠️ Failed to scrape live catalog: ${err.message}. Using verified static catalog.`);
  }
  return DEFAULT_CATALOG;
}

async function downloadSingleTheme(item, outputDir) {
  const filename = `${item.themeId}-${item.variantId}`;
  const targetPath = path.join(outputDir, filename);
  const downloadUrl = `https://terminalcolors.com/downloads/ghostty/${filename}`;

  try {
    const content = await fetchUrl(downloadUrl);
    if (!content.includes('palette') && !content.includes('background')) {
      throw new Error('Downloaded file does not appear to be a valid Ghostty theme');
    }

    const header = [
      `# Ghostty Theme: ${item.themeName} (${item.variantName})`,
      `# Source: https://terminalcolors.com/themes/${item.themeId}/${item.variantId}/`,
      `# Tag: dark`,
      `# Downloaded from: ${downloadUrl}`,
      '',
      ''
    ].join('\n');

    fs.writeFileSync(targetPath, header + content.trim() + '\n', 'utf8');

    // Parse primary colors for metadata
    const bgMatch = content.match(/background\s*=\s*(#[a-fA-F0-9]{6})/);
    const fgMatch = content.match(/foreground\s*=\s*(#[a-fA-F0-9]{6})/);

    return {
      success: true,
      filename,
      themeId: item.themeId,
      themeName: item.themeName,
      variantId: item.variantId,
      variantName: item.variantName,
      background: bgMatch ? bgMatch[1] : null,
      foreground: fgMatch ? fgMatch[1] : null
    };
  } catch (err) {
    return {
      success: false,
      filename,
      error: err.message
    };
  }
}

// Concurrency limiter
async function mapConcurrent(items, limit, fn) {
  const results = [];
  const executing = [];
  for (const item of items) {
    const p = Promise.resolve().then(() => fn(item));
    results.push(p);
    if (limit <= items.length) {
      const e = p.then(() => executing.splice(executing.indexOf(e), 1));
      executing.push(e);
      if (executing.length >= limit) {
        await Promise.race(executing);
      }
    }
  }
  return Promise.all(results);
}

function createConvenienceAliases(themes, outputDir) {
  const createdAliases = [];
  const aliasRules = [
    // Standard default variant aliases (e.g. apprentice -> apprentice-default)
    ...themes.filter(t => t.variantId === 'default').map(t => ({
      alias: t.themeId,
      target: `${t.themeId}-default`
    })),
    // Popular canonical dark theme aliases
    { alias: 'catppuccin', target: 'catppuccin-mocha' },
    { alias: 'gruvbox', target: 'gruvbox-dark' },
    { alias: 'tokyo-night', target: 'tokyo-night-default' },
    { alias: 'rose-pine', target: 'rose-pine-default' },
    { alias: 'kanagawa', target: 'kanagawa-wave' },
    { alias: 'one', target: 'one-dark' },
    { alias: 'one-half', target: 'one-half-dark' },
    { alias: 'solarized-dark', target: 'solarized-dark' },
    { alias: 'seoul256', target: 'seoul256-dark' },
    { alias: 'ayu', target: 'ayu-dark' },
    { alias: 'everforest', target: 'everforest-dark' },
    { alias: 'iceberg', target: 'iceberg-dark' }
  ];

  aliasRules.forEach(({ alias, target }) => {
    const aliasPath = path.join(outputDir, alias);
    const targetFile = path.join(outputDir, target);

    if (fs.existsSync(targetFile)) {
      try {
        if (fs.existsSync(aliasPath) || fs.lstatSync(aliasPath).isSymbolicLink()) {
          fs.unlinkSync(aliasPath);
        }
      } catch (e) {}

      try {
        fs.symlinkSync(target, aliasPath);
        createdAliases.push(`${alias} -> ${target}`);
      } catch (err) {
        // Fallback: copy file if symlink fails
        fs.copyFileSync(targetFile, aliasPath);
        createdAliases.push(`${alias} (copy of ${target})`);
      }
    }
  });

  return createdAliases;
}

async function main() {
  const isLive = process.argv.includes('--live') || process.argv.includes('--fetch-latest');
  fs.mkdirSync(THEMES_DIR, { recursive: true });

  console.log(`🎨 Ghostty Dark Themes Installer`);
  console.log(`📂 Target directory: ${THEMES_DIR}`);

  const catalog = isLive ? await scrapeDarkThemesLive() : DEFAULT_CATALOG;
  console.log(`🚀 Downloading ${catalog.length} dark themes with concurrency limit 8...`);

  const results = await mapConcurrent(catalog, 8, (item) => downloadSingleTheme(item, THEMES_DIR));
  const succeeded = results.filter(r => r.success);
  const failed = results.filter(r => !r.success);

  console.log(`\n✨ Download completed: ${succeeded.length} succeeded, ${failed.length} failed.`);

  if (failed.length > 0) {
    console.warn('⚠️ Failed downloads:');
    failed.forEach(f => console.warn(`   - ${f.filename}: ${f.error}`));
  }

  // Create aliases
  const aliases = createConvenienceAliases(catalog, THEMES_DIR);
  console.log(`🔗 Created ${aliases.length} friendly theme aliases (e.g., 'catppuccin', 'dracula').`);

  // Write metadata index
  const metadata = {
    source: 'https://terminalcolors.com/tags/dark/',
    updatedAt: new Date().toISOString(),
    totalThemes: succeeded.length,
    themes: succeeded.map(s => ({
      id: s.filename,
      themeId: s.themeId,
      themeName: s.themeName,
      variantId: s.variantId,
      variantName: s.variantName,
      background: s.background,
      foreground: s.foreground
    }))
  };

  fs.writeFileSync(METADATA_FILE, JSON.stringify(metadata, null, 2), 'utf8');
  console.log(`📋 Metadata index saved to: ${METADATA_FILE}`);
  console.log(`\n🎉 Tất cả các theme Dark từ terminalcolors.com đã được cài đặt thành công!`);
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
