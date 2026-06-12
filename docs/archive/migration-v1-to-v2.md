# 🚀 Migration Guide: v1.x → v2.0.0

This guide helps you upgrade from the monolithic `CLAUDE.md` (v1.x) to the modular structure (v2.0.0).

---

## 📂 What Changed

### Before (v1.0.0)
```
~/.claude/
└── CLAUDE.md (1,818 lines - everything in one file)
```
*   **View v1.0.0 monolithic file**: [GitHub Commit v1.0.0](https://github.com/nguyen-phan123/.dotfiles/blob/v1.0.0/claude/.claude/CLAUDE.md)
*   **Raw download**: [Raw monolithic CLAUDE.md](https://github.com/nguyen-phan123/.dotfiles/raw/v1.0.0/claude/.claude/CLAUDE.md)

### After (v2.0.0)
```
~/.claude/
├── CLAUDE.md (156 lines - core + quick reference)
└── docs/
    ├── testing.md (238 lines)
    ├── typescript.md (305 lines)
    ├── code-style.md (370 lines)
    ├── workflow.md (671 lines)
    ├── examples.md (118 lines)
    └── working-with-claude.md (74 lines)
```
> [!NOTE]
> **Content is identical**: v2.0.0 splits the v1.0.0 monolithic file into modular files with imports. No content was removed or changed, just reorganized.

---

## 🚦 Do You Need to Migrate?

> [!TIP]
> **Your old setup still works**:
> The v1.0.0 monolithic `CLAUDE.md` continues to work perfectly. You can upgrade when ready.

> [!WARNING]
> **You SHOULD migrate if**:
> *   You want faster Claude Code load times (91% reduction: 1,818 → 156 lines).
> *   You prefer modular, on-demand documentation.
> *   You want easier maintenance and version control.

> [!CAUTION]
> **You MUST migrate if**:
> *   You created custom imports referencing the old structure.
> *   You modified `CLAUDE.md` and want to merge upstream improvements.

---

## 🛠️ Migration Steps

### Option 1: Clean Install (Recommended)

**If you're using the full dotfiles with GNU Stow:**
```bash
# 1. Backup your current setup
cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.v1.backup

# 2. Pull latest changes
cd ~/.dotfiles
git pull origin main

# 3. Reinstall (stow will update the files)
stow -R -t ~ claude

# 4. Verify the new structure
ls -la ~/.claude/docs/
```

**If you installed CLAUDE.md manually:**
```bash
# 1. Backup current file
cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.v1.backup

# 2. Install new structure
cd /tmp
git clone https://github.com/nguyen-phan123/.dotfiles.git
cd .dotfiles

# 3. Copy all files
cp claude/.claude/CLAUDE.md ~/.claude/
mkdir -p ~/.claude/docs
cp -r claude/.claude/docs/* ~/.claude/docs/

# 4. Copy agents if you want them
mkdir -p ~/.claude/agents
cp -r claude/.claude/agents/* ~/.claude/agents/
```

### Option 2: Keep v1.0.0 (Stay on old version)
```bash
# Check out v1.0.0 tag explicitly
cd ~/.dotfiles
git checkout v1.0.0

# Or download the specific version
curl -L https://github.com/nguyen-phan123/.dotfiles/raw/v1.0.0/claude/.claude/CLAUDE.md \
  -o ~/.claude/CLAUDE.md
```

---

## 🔍 Verification

After migration, verify the new structure works:

### 1. Check files exist
```bash
# Main file should be ~156 lines
wc -l ~/.claude/CLAUDE.md

# Docs directory should have 6 files
ls ~/.claude/docs/
# Should show:
#   code-style.md
#   examples.md
#   testing.md
#   typescript.md
#   workflow.md
#   working-with-claude.md
```

### 2. Test with Claude Code
Open any project in Claude Code and use the `/memory` command:
```
/memory
```
You should see:
*   Main `CLAUDE.md` loaded.
*   Import references to `@~/.claude/docs/*.md`.

---

## 📝 Custom Modifications

### If you modified CLAUDE.md in v1.0.0

*   **Option A: Apply modifications to new structure**
    1. Compare your backup to the new files:
       ```bash
       diff ~/.claude/CLAUDE.md.v1.backup ~/.claude/CLAUDE.md
       ```
    2. Identify which section your changes belong to.
    3. Apply changes to the appropriate file:
       *   Testing changes → `~/.claude/docs/testing.md`
       *   TypeScript changes → `~/.claude/docs/typescript.md`
       *   etc.

*   **Option B: Keep custom instructions separate**
    Create a new file for your custom additions:
    ```bash
    # Create custom instructions file
    cat > ~/.claude/my-custom-instructions.md << 'EOF'
    # My Custom Development Rules
    
    ## My Team's Specific Patterns
    - Use React Query for all data fetching
    - Prefer Tailwind CSS for styling
    - etc.
    EOF
    ```
    Then import it in your project `CLAUDE.md`:
    ```markdown
    # In your project's CLAUDE.md
    @~/.claude/CLAUDE.md
    @~/.claude/my-custom-instructions.md
    ```

---

## ⚠️ Import Paths Changed

> [!IMPORTANT]
> **Absolute Paths Required**: All imports in v2.0.0 use absolute paths for dotfiles compatibility:
> ```markdown
> # ❌ v1.0.0 style (if you had custom imports)
> See @docs/testing.md
> 
> # ✅ v2.0.0 style (required)
> See @~/.claude/docs/testing.md
> ```
> The official Claude Code documentation explicitly shows `@~/.claude/...` syntax. Relative path resolution from `~/.claude/CLAUDE.md` is undocumented, so we use absolute paths for safety.

---

## 🐛 Troubleshooting

### "I don't see the detailed docs loading"
1. Check files exist:
   ```bash
   ls -la ~/.claude/docs/
   ```
2. Check file permissions:
   ```bash
   chmod 644 ~/.claude/docs/*.md
   ```
3. Use `/memory` command in Claude Code to see what's loaded.

### "My custom changes are gone"
1. Check your backup:
   ```bash
   cat ~/.claude/CLAUDE.md.v1.backup
   ```
2. Manually reapply changes to the appropriate modular file.

---

## 🔄 Rollback Plan

If you need to rollback to v1.0.0:
```bash
# Using git
cd ~/.dotfiles
git checkout v1.0.0
stow -R -t ~ claude

# Or download directly
curl -L https://github.com/nguyen-phan123/.dotfiles/raw/v1.0.0/claude/.claude/CLAUDE.md \
  -o ~/.claude/CLAUDE.md

# Remove docs directory if you don't want it
rm -rf ~/.claude/docs
```
