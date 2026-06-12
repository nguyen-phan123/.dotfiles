const fs = require('fs');
const path = require('path');
const os = require('os');

function syncMcp() {
  const homeDir = os.homedir();
  const sourcePath = path.join(homeDir, '.gemini', 'settings.json');

  console.log('🔍 Checking source...');
  console.log(`Source: ${sourcePath}`);

  if (!fs.existsSync(sourcePath)) {
    console.error(`❌ Source settings file not found: ${sourcePath}`);
    process.exit(1);
  }

  let sourceSettings;
  try {
    const sourceContent = fs.readFileSync(sourcePath, 'utf8');
    sourceSettings = JSON.parse(sourceContent);
  } catch (err) {
    console.error(`❌ Failed to parse source settings JSON: ${err.message}`);
    process.exit(1);
  }

  const sourceServers = sourceSettings.mcpServers || {};
  const sourceServerKeys = Object.keys(sourceServers);
  if (sourceServerKeys.length === 0) {
    console.log('⚠️ No MCP servers found in source settings.');
    return;
  }

  const targets = [
    {
      dir: path.join(homeDir, '.gemini', 'antigravity-ide'),
      file: 'mcp_config.json',
      label: 'Antigravity IDE'
    },
    {
      dir: path.join(homeDir, '.gemini', 'antigravity'),
      file: 'mcp_config.json',
      label: 'Antigravity'
    },
    {
      dir: path.join(homeDir, '.gemini', 'config'),
      file: 'mcp_config.json',
      label: 'Antigravity CLI / Gemini Config'
    }
  ];

  for (const target of targets) {
    const targetPath = path.join(target.dir, target.file);
    const backupPath = path.join(target.dir, `${target.file}.bak`);

    console.log(`\n🔄 Syncing MCP configuration to ${target.label}...`);
    console.log(`Target: ${targetPath}`);

    // Ensure target directory exists
    if (!fs.existsSync(target.dir)) {
      console.log(`📁 Creating target directory: ${target.dir}`);
      fs.mkdirSync(target.dir, { recursive: true });
    }

    let targetConfig = { mcpServers: {} };
    if (fs.existsSync(targetPath)) {
      try {
        const targetContent = fs.readFileSync(targetPath, 'utf8');
        targetConfig = JSON.parse(targetContent);
        if (!targetConfig.mcpServers) {
          targetConfig.mcpServers = {};
        }
      } catch (err) {
        console.warn(`⚠️ Failed to parse existing target config, initializing new: ${err.message}`);
      }
    }

    // Create backup if target exists
    if (fs.existsSync(targetPath)) {
      try {
        fs.copyFileSync(targetPath, backupPath);
        console.log(`💾 Created backup at ${backupPath}`);
      } catch (err) {
        console.warn(`⚠️ Failed to create backup: ${err.message}`);
      }
    }

    // Merge logic
    let updatedCount = 0;
    let addedCount = 0;

    for (const serverName of sourceServerKeys) {
      const sourceServer = sourceServers[serverName];
      if (targetConfig.mcpServers[serverName]) {
        updatedCount++;
      } else {
        addedCount++;
      }

      const existingServer = targetConfig.mcpServers[serverName] || {};
      
      // Perform deep-merge of environment variables
      const mergedEnv = Object.assign(
        {},
        existingServer.env || {},
        sourceServer.env || {}
      );

      // Merge server configuration
      targetConfig.mcpServers[serverName] = Object.assign(
        {},
        existingServer,
        sourceServer,
        { env: mergedEnv }
      );
    }

    // Write updated configuration with 2-spaces indentation
    try {
      fs.writeFileSync(targetPath, JSON.stringify(targetConfig, null, 2) + '\n', 'utf8');
      console.log(`✨ Successfully synchronized to ${target.label}!`);
      console.log(`   - Added: ${addedCount} servers`);
      console.log(`   - Updated/Merged: ${updatedCount} servers`);
    } catch (err) {
      console.error(`❌ Failed to write target config for ${target.label}: ${err.message}`);
    }
  }
}

function syncSkills() {
  const homeDir = os.homedir();
  const sourceSkillsDir = path.join(homeDir, '.gemini', 'skills');

  console.log('\n🔄 Running Agent Skills Sync...');
  console.log(`Source Skills Dir: ${sourceSkillsDir}`);

  if (!fs.existsSync(sourceSkillsDir)) {
    console.log('⚠️ Central skills directory not found. Skipping skills sync.');
    return;
  }

  const activeSkills = [];
  try {
    const items = fs.readdirSync(sourceSkillsDir);
    for (const item of items) {
      const itemPath = path.join(sourceSkillsDir, item);
      try {
        const stat = fs.lstatSync(itemPath);
        let targetPath = null;
        if (stat.isSymbolicLink()) {
          targetPath = fs.readlinkSync(itemPath);
        } else {
          targetPath = itemPath;
        }
        activeSkills.push({
          name: item,
          targetPath: targetPath
        });
      } catch (e) {
        console.warn(`⚠️ Failed to read skill stat/link for ${item}: ${e.message}`);
      }
    }
  } catch (err) {
    console.error(`❌ Failed to read central skills: ${err.message}`);
    return;
  }

  const targets = [
    {
      dir: path.join(homeDir, '.gemini', 'antigravity-ide', 'skills'),
      label: 'Antigravity IDE'
    },
    {
      dir: path.join(homeDir, '.gemini', 'antigravity', 'skills'),
      label: 'Antigravity'
    },
    {
      dir: path.join(homeDir, '.gemini', 'config', 'skills'),
      label: 'Antigravity CLI / Gemini Config'
    }
  ];

  for (const target of targets) {
    const targetSkillsDir = target.dir;
    console.log(`\nSyncing skills to ${target.label}...`);
    console.log(`Target: ${targetSkillsDir}`);

    let isDirOrSymlink = false;
    let isBrokenSymlink = false;
    try {
      const stat = fs.lstatSync(targetSkillsDir);
      isDirOrSymlink = stat.isDirectory() || stat.isSymbolicLink();
      if (stat.isSymbolicLink()) {
        try {
          fs.statSync(targetSkillsDir);
        } catch (e) {
          isBrokenSymlink = true;
        }
      }
    } catch (e) {}

    if (isBrokenSymlink) {
      console.log(`🗑️ Removing broken symlink at: ${targetSkillsDir}`);
      try {
        fs.unlinkSync(targetSkillsDir);
        isDirOrSymlink = false;
      } catch (e) {
        console.error(`❌ Failed to delete broken symlink ${targetSkillsDir}: ${e.message}`);
      }
    }

    if (!isDirOrSymlink) {
      try {
        fs.mkdirSync(targetSkillsDir, { recursive: true });
        console.log(`📁 Created directory: ${targetSkillsDir}`);
      } catch (e) {
        console.error(`❌ Failed to create skills directory ${targetSkillsDir}: ${e.message}`);
        continue;
      }
    }

    // Read existing files in target
    let targetItems = [];
    try {
      targetItems = fs.readdirSync(targetSkillsDir);
    } catch (e) {
      console.warn(`⚠️ Failed to read target skills directory ${targetSkillsDir}: ${e.message}`);
      continue;
    }

    // Map active skill names for quick lookup
    const activeSkillNames = new Set(activeSkills.map(s => s.name));

    // Pruning: remove any symlink/directory in target that is not active
    for (const item of targetItems) {
      if (item === 'skills-lock.json') continue;

      const itemPath = path.join(targetSkillsDir, item);
      let isTargetSymlink = false;
      let isTargetDir = false;
      try {
        const stat = fs.lstatSync(itemPath);
        isTargetSymlink = stat.isSymbolicLink();
        isTargetDir = stat.isDirectory();
      } catch (e) {}

      if (!activeSkillNames.has(item)) {
        if (isTargetSymlink) {
          try {
            fs.unlinkSync(itemPath);
            console.log(`🗑️ Pruned obsolete symlink: ${item}`);
          } catch (e) {
            console.warn(`⚠️ Failed to delete obsolete link ${itemPath}: ${e.message}`);
          }
        } else if (isTargetDir) {
          try {
            fs.rmSync(itemPath, { recursive: true, force: true });
            console.log(`🗑️ Pruned obsolete directory: ${item}`);
          } catch (e) {
            console.warn(`⚠️ Failed to delete obsolete directory ${itemPath}: ${e.message}`);
          }
        }
      }
    }

    // Syncing: create symlink for each active skill if it doesn't exist or points to wrong target
    let syncedCount = 0;
    for (const skill of activeSkills) {
      const destPath = path.join(targetSkillsDir, skill.name);
      
      let exists = false;
      let existingTarget = null;
      try {
        const stat = fs.lstatSync(destPath);
        exists = true;
        if (stat.isSymbolicLink()) {
          existingTarget = fs.readlinkSync(destPath);
        }
      } catch (e) {}

      if (exists) {
        if (existingTarget !== skill.targetPath) {
          try {
            const destStat = fs.lstatSync(destPath);
            if (destStat.isDirectory() && !destStat.isSymbolicLink()) {
              fs.rmSync(destPath, { recursive: true, force: true });
            } else {
              fs.unlinkSync(destPath);
            }
            fs.symlinkSync(skill.targetPath, destPath, 'dir');
            syncedCount++;
          } catch (e) {
            console.error(`❌ Failed to recreate symlink for ${skill.name}: ${e.message}`);
          }
        }
      } else {
        try {
          fs.symlinkSync(skill.targetPath, destPath, 'dir');
          syncedCount++;
        } catch (e) {
          console.error(`❌ Failed to create symlink for ${skill.name} pointing to ${skill.targetPath}: ${e.message}`);
        }
      }
    }

    console.log(`✨ Synchronized ${syncedCount} skills for ${target.label}`);
  }
}

syncMcp();
syncSkills();
