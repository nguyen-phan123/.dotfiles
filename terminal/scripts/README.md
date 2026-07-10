# Terminal & Editor Theme Switching System

Unified theme switching for terminal and editor, optimized for nearsighted users working in varying lighting conditions.

## 🎯 Purpose

This system provides easy switching between light and dark themes across terminal and editor, specifically optimized for:
- **Nearsighted users** who read code for extended periods
- **Office environments** with bright electric lighting (light mode)
- **Home/night work** in low light conditions (dark mode)
- **Consistent UI** between terminal (Ghostty/cmux) and editor (LunarVim)

## 🏗️ Architecture

### Config Structure
```
terminal/
├── scripts/
│   ├── theme-switch.sh      # Theme switching script
│   └── README.md            # This file
├── ghostty/.config/ghostty/
│   └── config               # Unified, natively adaptive config
└── cmux/.config/cmux/
    └── cmux.json            # Unified, natively adaptive config

coding/lvim/.config/lvim/
├── config.light.lua         # LunarVim light mode (Solarized Light)
├── config.dark.lua          # LunarVim dark mode (Solarized Dark)
└── config.lua -> config.light.lua  # Symlink (current theme)
```

### Optimization Features

Both modes include:
- **Font size 16px** (optimal for nearsighted users at 50-60cm viewing distance)
- **JetBrains Mono font** (better character distinction with ligatures)
- **Block cursor with blink** (easier to locate)
- **Window padding 8px** (comfortable margins)

**Light Mode** (Natively adaptive `GitHub Light High Contrast` for terminal, `Solarized Light` for editor):
- Maximum contrast for bright office environments
- Background opacity 0.95 (reduces glare on glossy MacBook screens)
- Synced appearance across terminal and editor

**Dark Mode** (Natively adaptive `Solarized Dark Patched` for terminal, `Solarized Dark` for editor):
- Comfortable for night/low light work
- Background opacity 0.95 (maintained for visual consistency)
- Consistent theme across all tools

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

The system is split into **Natively Adaptive** components (Terminal) and **Symlink Swapped** components (LunarVim):

1. **Natively Adaptive (Ghostty & Cmux)**:
   - **Ghostty** uses native `theme = light:GitHub Light High Contrast,dark:Solarized Dark Patched` syntax, automatically toggling colors as macOS changes system appearance.
   - **Cmux** uses native `"appearance": "system"` syntax, instantly adjusting panel boundaries to follow the OS.
2. **Symlink Swapped (LunarVim)**:
   - The `theme-switch.sh` script swaps LunarVim's config between `config.light.lua` and `config.dark.lua` using symlinks.
   - `theme-switch.sh` still outputs status and accepts `light`/`dark` targets, but only performs filesystem writes for LunarVim.

## 📋 Multi-Machine Setup

### Natively Adaptive Configs
- Ghostty and cmux settings are identical across machines. They automatically look at the individual machine's system preference. No manual setup is needed.

### LunarVim Customization
On any machine, you can run `theme-dark` to lock LunarVim to dark theme or `theme-light` to lock it to light theme.

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

1. **Edit the unified config file**:
   - Edit the main configuration file at [terminal/ghostty/.config/ghostty/config](file:///Users/diqit/Documents/GitHub/config/dotfiles/terminal/ghostty/.config/ghostty/config).
   - Change the `theme = light:<light_theme>,dark:<dark_theme>` line to use any alternative Ghostty themes.

2. **Save changes** (Ghostty will auto-reload the settings in real-time)

3. **Commit changes** to the dotfiles repo to sync across machines

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
If 16px is too small or large, edit the unified `config`:
```
font-size = 18  # Increase to 18px
```

**Line height adjustment**:
If you want more/less vertical spacing:
```
line-height = 1.5  # Increase spacing
line-height = 1.3  # Decrease spacing
```
