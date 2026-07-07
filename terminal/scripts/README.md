# Terminal Theme Switching System

Dual-mode terminal configuration optimized for nearsighted users working in varying lighting conditions.

## 🎯 Purpose

This system provides easy switching between light and dark terminal themes, specifically optimized for:
- **Nearsighted users** who read code for extended periods
- **Office environments** with bright electric lighting (light mode)
- **Home/night work** in low light conditions (dark mode)

## 🏗️ Architecture

### Config Structure
```
terminal/
├── scripts/
│   ├── theme-switch.sh      # Theme switching script
│   └── README.md            # This file
├── ghostty/.config/ghostty/
│   ├── config.light         # Light mode config
│   ├── config.dark          # Dark mode config
│   └── config -> config.light  # Symlink (current theme)
└── cmux/.config/cmux/
    ├── cmux.light.json      # Light appearance
    ├── cmux.dark.json       # Dark appearance
    └── cmux.json -> cmux.light.json  # Symlink (current theme)
```

### Optimization Features

Both modes include:
- **Font size 16px** (optimal for nearsighted users at 50-60cm viewing distance)
- **JetBrains Mono font** (better character distinction with ligatures)
- **Block cursor with blink** (easier to locate)
- **Window padding 8px** (comfortable margins)

**Light Mode** (`GitHub Light High Contrast`):
- Maximum contrast for bright office environments
- Background opacity 0.95 (reduces glare on glossy MacBook screens)
- Synced with cmux light appearance

**Dark Mode** (`Solarized Dark Patched`):
- Comfortable for night/low light work
- Opaque background (opacity 1.0)
- Synced with cmux dark appearance

## 🚀 Usage

### Direct Script Usage
```bash
# Switch to light mode
~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh light

# Switch to dark mode
~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh dark

# Check current theme
~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh status

# Show help
~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh help
```

### Recommended: Shell Aliases

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Terminal theme switching
alias theme-light='~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh light'
alias theme-dark='~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh dark'
alias theme-status='~/Documents/GitHub/config/dotfiles/terminal/scripts/theme-switch.sh status'
```

Then reload your shell:
```bash
source ~/.zshrc
```

Now you can simply run:
```bash
theme-light   # Switch to light mode
theme-dark    # Switch to dark mode
theme-status  # Check current theme
```

## 🔄 How It Works

The script updates symlinks for both Ghostty and cmux configs simultaneously:

1. **Validates** that target config files exist
2. **Updates symlinks**:
   - `ghostty/config` → `config.light` or `config.dark`
   - `cmux/cmux.json` → `cmux.light.json` or `cmux.dark.json`
3. **Provides feedback** on what was changed

**Important**: You need to **restart Ghostty/cmux** after switching for changes to take effect.

## 📋 Multi-Machine Setup

### Default Configuration
- All machines default to **light mode** after syncing dotfiles
- Symlinks point to `config.light` and `cmux.light.json`

### Per-Machine Customization
On your home machine (used primarily at night), run once:
```bash
theme-dark
```

The symlink will persist across shell sessions and dotfiles syncs. You can always manually switch as needed.

## 🔧 Troubleshooting

### Theme doesn't change after running script
**Solution**: Restart Ghostty and cmux. Config changes only apply on restart.

### "Error: config file not found"
**Solution**: Ensure you're running from the correct dotfiles directory. Check that all config files exist:
```bash
ls -la ~/Documents/GitHub/config/dotfiles/terminal/ghostty/.config/ghostty/
ls -la ~/Documents/GitHub/config/dotfiles/terminal/cmux/.config/cmux/
```

### Symlink is broken
**Solution**: Re-run the theme switch script to recreate symlinks:
```bash
theme-light  # or theme-dark
```

### Want to check current theme
```bash
theme-status
```

This shows which config files are currently linked.

## 🎨 Customizing Themes

To modify theme settings:

1. **Edit the appropriate config file**:
   - Light mode: `terminal/ghostty/.config/ghostty/config.light`
   - Dark mode: `terminal/ghostty/.config/ghostty/config.dark`

2. **Restart Ghostty** to see changes

3. **Commit changes** to dotfiles repo to sync across machines

### Available Ghostty Themes

Light mode alternatives:
- `GitHub Light` (current: `GitHub Light High Contrast`)
- `Solarized Light`
- `One Light`

Dark mode alternatives:
- `Solarized Dark` (current: `Solarized Dark Patched`)
- `GitHub Dark`
- `Nord`
- `Dracula`

Change the `theme = "..."` line in the respective config file.

## 📚 References

- [Ghostty Configuration](https://ghostty.org/docs/config)
- [Cmux Documentation](https://github.com/manaflow-ai/cmux)
- Optimization based on research for nearsighted users reading text for extended periods

## 💡 Tips

**For office work** (bright lighting):
- Use `theme-light` for maximum contrast
- Position screen to minimize glare
- Take breaks every 60-90 minutes

**For night work** (low lighting):
- Use `theme-dark` to reduce eye strain
- Ensure room has some ambient light (don't work in complete darkness)
- Consider f.lux or macOS Night Shift for additional blue light reduction

**Font size adjustment**:
If 16px is too small or large, edit both `config.light` and `config.dark`:
```
font-size = 18  # Increase to 18px
```

**Line height adjustment**:
If you want more/less vertical spacing:
```
line-height = 1.5  # Increase spacing
line-height = 1.3  # Decrease spacing
```
