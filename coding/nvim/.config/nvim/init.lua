-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.deprecation_warnings = false

-- Disable netrw (let nvim-tree handle file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.clipboard = "unnamedplus"



-- Bootstrap lazy.nvim and load plugins if NOT in VSCode
if vim.g.vscode then
  -- ==========================================
  -- VSCode Neovim Specific Configuration
  -- ==========================================
  local keymap = vim.keymap

  -- Leader Key Mappings (LunarVim defaults bridged to VSCode)
  
  -- Space + f hoặc Space + f + f: Find File (Quick Open)
  keymap.set('n', '<leader>f', "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", { desc = 'Fuzzy find files' })
  keymap.set('n', '<leader>ff', "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", { desc = 'Fuzzy find files' })
  
  -- Space + s + t hoặc Space + f + g: Search Text (Find in Files)
  keymap.set('n', '<leader>st', "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>", { desc = 'Search text' })
  keymap.set('n', '<leader>fg', "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>", { desc = 'Search text' })

  -- Space + e: Toggle Sidebar File Explorer
  keymap.set('n', '<leader>e', "<cmd>lua require('vscode').action('workbench.view.explorer')<CR>", { desc = 'Toggle Explorer' })

  -- Space + c: Close Editor Tab (Buffer Close)
  keymap.set('n', '<leader>c', "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", { desc = 'Close Buffer' })

  -- Space + w: Save File (Save Buffer)
  keymap.set('n', '<leader>w', "<cmd>lua require('vscode').action('workbench.action.files.save')<CR>", { desc = 'Save File' })

  -- Space + /: Toggle Comment
  keymap.set('n', '<leader>/', "<cmd>lua require('vscode').action('editor.action.commentLine')<CR>", { desc = 'Toggle Comment' })

  -- Standard LSP Navigation Keymaps
  keymap.set('n', 'gd', "<cmd>lua require('vscode').action('editor.action.revealDefinition')<CR>", { desc = 'Go to definition' })
  keymap.set('n', 'gD', "<cmd>lua require('vscode').action('editor.action.peekDefinition')<CR>", { desc = 'Peek definition' })
  keymap.set('n', 'gi', "<cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>", { desc = 'Go to implementation' })
  keymap.set('n', 'gr', "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>", { desc = 'Go to references' })
  keymap.set('n', 'K', "<cmd>lua require('vscode').action('editor.action.showHover')<CR>", { desc = 'Show hover' })

  -- Copy entire file (<leader>ya)
  keymap.set('n', '<leader>ya', ':%y+<CR>', { desc = 'Copy entire file' })
else
  -- Terminal-only settings
  vim.opt.termguicolors = true
  vim.opt.signcolumn = "yes"
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300

  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Load plugins
  require("lazy").setup("plugins")

  -- Load keymaps
  require("keymaps")
end

