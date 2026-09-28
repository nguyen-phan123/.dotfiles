const fs = require('fs');
const path = require('path');
const os = require('os');

function syncMcp() {
  const homeDir = os.homedir();
  const sourcePath = path.join(homeDir, '.gemini', 'settings.json');

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
    return { skipped: true, reason: 'No MCP servers found in settings.json' };
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

  const results = {};

  for (const target of targets) {
    const targetPath = path.join(target.dir, target.file);
    const backupPath = path.join(target.dir, `${target.file}.bak`);

    try {
      // Ensure target directory exists
      if (!fs.existsSync(target.dir)) {
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
          // ignore and initialize new
        }
      }

      // Create backup if target exists
      if (fs.existsSync(targetPath)) {
        try {
          fs.copyFileSync(targetPath, backupPath);
        } catch (err) {
          // ignore backup fail
        }
      }

      let updatedCount = 0;
      let addedCount = 0;

      const newMcpServers = {};

      for (const serverName of sourceServerKeys) {
        const sourceServer = sourceServers[serverName];
        if (!sourceServer) continue;

        if (targetConfig.mcpServers[serverName]) {
          updatedCount++;
        } else {
          addedCount++;
        }

        const serverCopy = JSON.parse(JSON.stringify(sourceServer));

        // Delete invalid/internal attributes if present
        delete serverCopy["$typeName"];

        // Auto-fix PATH and commands for local executables
        if (serverCopy.command) {
          serverCopy.env = serverCopy.env || {};
          if (!serverCopy.env.PATH) {
            serverCopy.env.PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          } else if (!serverCopy.env.PATH.includes("/opt/homebrew/bin")) {
            serverCopy.env.PATH = `/opt/homebrew/bin:${serverCopy.env.PATH}`;
          }

          if (serverCopy.command === "npx") serverCopy.command = "/opt/homebrew/bin/npx";
          if (serverCopy.command === "node") serverCopy.command = "/opt/homebrew/bin/node";
          if (serverCopy.command === "codegraph") serverCopy.command = "/opt/homebrew/bin/codegraph";
          if (serverCopy.command === "uvx") serverCopy.command = "/opt/homebrew/bin/uvx";
        }

        // Standardize SSE fields (both serverUrl and url)
        if (serverCopy.serverUrl && !serverCopy.url) {
          serverCopy.url = serverCopy.serverUrl;
        } else if (serverCopy.url && !serverCopy.serverUrl) {
          serverCopy.serverUrl = serverCopy.url;
        }

        newMcpServers[serverName] = serverCopy;
      }

      targetConfig.mcpServers = newMcpServers;

      fs.writeFileSync(targetPath, JSON.stringify(targetConfig, null, 2) + '\n', 'utf8');
      results[target.label] = { added: addedCount, updated: updatedCount, success: true };
    } catch (err) {
      results[target.label] = { error: err.message, success: false };
    }
  }

  return { skipped: false, results };
}

function syncSkills() {
  const homeDir = os.homedir();
  const activeSkills = [];

  const scanDir = (dir) => {
    if (!fs.existsSync(dir)) return;
    try {
      const items = fs.readdirSync(dir);
      for (const item of items) {
        if (item === 'skills-lock.json' || item === '.DS_Store') continue;
        const itemPath = path.join(dir, item);
        try {
          const stat = fs.lstatSync(itemPath);
          let targetPath = null;
          if (stat.isSymbolicLink()) {
            targetPath = fs.readlinkSync(itemPath);
          } else {
            targetPath = itemPath;
          }
          
          if (!activeSkills.some(s => s.name === item)) {
            activeSkills.push({
              name: item,
              targetPath: targetPath
            });
          }
        } catch (e) {
          // ignore
        }
      }
    } catch (err) {
      console.warn(`⚠️ Failed to read skills from ${dir}: ${err.message}`);
    }
  };

  const centralGeminiSkillsDir = path.join(homeDir, '.gemini', 'skills');
  const centralAgentsSkillsDir = path.join(homeDir, '.agents', 'skills');

  scanDir(centralGeminiSkillsDir);
  scanDir(centralAgentsSkillsDir);

  if (activeSkills.length === 0) {
    return { skipped: true, reason: 'No skills found in central directories' };
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

  const results = {};

  for (const target of targets) {
    const targetSkillsDir = target.dir;
    let syncedCount = 0;

    try {
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
        fs.unlinkSync(targetSkillsDir);
        isDirOrSymlink = false;
      }

      if (!isDirOrSymlink) {
        fs.mkdirSync(targetSkillsDir, { recursive: true });
      }

      let targetItems = [];
      try {
        targetItems = fs.readdirSync(targetSkillsDir);
      } catch (e) {
        // ignore
      }

      const activeSkillNames = new Set(activeSkills.map(s => s.name));

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
            fs.unlinkSync(itemPath);
          } else if (isTargetDir) {
            fs.rmSync(itemPath, { recursive: true, force: true });
          }
        }
      }

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
            const destStat = fs.lstatSync(destPath);
            if (destStat.isDirectory() && !destStat.isSymbolicLink()) {
              fs.rmSync(destPath, { recursive: true, force: true });
            } else {
              fs.unlinkSync(destPath);
            }
            fs.symlinkSync(skill.targetPath, destPath, 'dir');
            syncedCount++;
          }
        } else {
          fs.symlinkSync(skill.targetPath, destPath, 'dir');
          syncedCount++;
        }
      }

      results[target.label] = { synced: syncedCount, success: true };
    } catch (err) {
      results[target.label] = { error: err.message, success: false };
    }
  }

  return { skipped: false, results };
}

function main() {
  const mcp = syncMcp();
  const skills = syncSkills();

  console.log('\n🔄 Syncing MCP & Skills Configuration:');

  const environments = [
    'Antigravity IDE',
    'Antigravity',
    'Antigravity CLI / Gemini Config'
  ];

  const labelWidth = 31;
  const mcpWidth = 22;
  const skillsWidth = 15;

  const horizontalLine = `┌${'─'.repeat(labelWidth + 2)}┬${'─'.repeat(mcpWidth + 2)}┬${'─'.repeat(skillsWidth + 2)}┐`;
  const dividerLine = `├${'─'.repeat(labelWidth + 2)}┼${'─'.repeat(mcpWidth + 2)}┼${'─'.repeat(skillsWidth + 2)}┤`;
  const bottomLine = `└${'─'.repeat(labelWidth + 2)}┴${'─'.repeat(mcpWidth + 2)}┴${'─'.repeat(skillsWidth + 2)}┘`;

  function pad(str, width) {
    return str + ' '.repeat(Math.max(0, width - str.length));
  }

  console.log(horizontalLine);
  console.log(`│ ${pad('Environment', labelWidth)} │ ${pad('MCP Sync', mcpWidth)} │ ${pad('Skills Sync', skillsWidth)} │`);
  console.log(dividerLine);

  for (const env of environments) {
    let mcpText = '';
    if (mcp.skipped) {
      mcpText = 'Skipped';
    } else {
      const res = mcp.results[env];
      if (!res) {
        mcpText = 'N/A';
      } else if (!res.success) {
        mcpText = `Error: ${res.error.substring(0, 15)}`;
      } else {
        mcpText = `+${res.added} / ~${res.updated}`;
      }
    }

    let skillsText = '';
    if (skills.skipped) {
      skillsText = 'Skipped';
    } else {
      const res = skills.results[env];
      if (!res) {
        skillsText = 'N/A';
      } else if (!res.success) {
        skillsText = `Error: ${res.error.substring(0, 8)}`;
      } else {
        skillsText = `${res.synced} skills`;
      }
    }

    console.log(`│ ${pad(env, labelWidth)} │ ${pad(mcpText, mcpWidth)} │ ${pad(skillsText, skillsWidth)} │`);
  }

  console.log(bottomLine);
}

module.exports = { syncMcp, syncSkills };

if (require.main === module) {
  main();
}

