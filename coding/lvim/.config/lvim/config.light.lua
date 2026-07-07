-- ==========================================
-- LunarVim Configuration - Light Mode
-- Theme: Solarized Light (matching terminal)
-- ==========================================

-- ==========================================
-- 1. Basic Settings
-- ==========================================
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "solarized"
lvim.leader = " "

-- Set background to light
vim.o.background = "light"

-- Options migrated from init.lua
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"

-- ==========================================
-- 2. Custom Keybindings
-- ==========================================
-- Copy entire file (<leader>ya from keymaps.lua)
lvim.keys.normal_mode["<leader>ya"] = ":%y+<CR>"

-- ==========================================
-- 3. Plugins
-- ==========================================
lvim.plugins = {
  -- Theme: Solarized (matching terminal theme)
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized").setup({
        variant = "summer", -- Light variant
        transparent = false,
        styles = {
          comments = { italic = true },
          functions = { bold = true },
          variables = {},
        },
        enables = {
          bufferline = true,
          cmp = true,
          diagnostic = true,
          gitsigns = true,
          lsp = true,
          telescope = true,
          treesitter = true,
          notify = true,
          mini = true,
          noice = true,
        },
      })
      vim.cmd("colorscheme solarized")
    end,
  },

  -- Flutter Tools with FVM support (from dart.lua)
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim"
    },
    config = function()
      -- FVM Flutter SDK detection logic
      local function get_fvm_flutter_sdk()
        local fvm_flutter_sdk = vim.fn.getcwd() .. "/.fvm/flutter_sdk"
        if vim.fn.isdirectory(fvm_flutter_sdk) == 1 then
          return fvm_flutter_sdk
        end
        return nil
      end

      local flutter_sdk = get_fvm_flutter_sdk()
      local flutter_path = flutter_sdk and (flutter_sdk .. "/bin/flutter") or "flutter"

      require("flutter-tools").setup({
        flutter_path = flutter_path,
        flutter_lookup_cmd = nil,
        fvm = true,
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        lsp = {
          color = {
            enabled = true,
            background = false,
            virtual_text = true,
          },
          on_attach = function(client, bufnr)
            -- Flutter-specific keybindings are handled by WhichKey below
          end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
          },
        },
      })
    end,
  },
}

-- ==========================================
-- 4. WhichKey Mappings
-- ==========================================
-- Unified Find & Flutter menu under <leader>f
lvim.builtin.which_key.mappings["f"] = {
  name = "Find & Flutter",

  -- Telescope keymaps (from keymaps.lua)
  f = { "<cmd>Telescope find_files<cr>", "Find File" },
  g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
  h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },

  -- Flutter keymaps (from dart.lua - adjusted for conflicts)
  r = { "<cmd>FlutterRun<cr>", "Flutter Run" },
  q = { "<cmd>FlutterQuit<cr>", "Flutter Quit" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  l = { "<cmd>FlutterReload<cr>", "Flutter Hot Reload" }, -- Changed from 'fr' to 'fl'
  R = { "<cmd>FlutterRestart<cr>", "Flutter Hot Restart" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Flutter Outline" },
}

-- ==========================================
-- 5. Treesitter Configuration
-- ==========================================
lvim.builtin.treesitter.ensure_installed = {
  "lua",
  "dart",
  "json",
  "yaml",
  "markdown",
}
lvim.builtin.treesitter.highlight.enabled = true

-- ==========================================
-- 6. LSP Configuration
-- ==========================================
-- Standard LSP keybindings (from dart.lua)
lvim.lsp.buffer_mappings.normal_mode = {
  gd = { vim.lsp.buf.definition, "Go to definition" },
  gD = { vim.lsp.buf.declaration, "Go to declaration" },
  gi = { vim.lsp.buf.implementation, "Go to implementation" },
  gr = { vim.lsp.buf.references, "Find references" },
  K = { vim.lsp.buf.hover, "Show hover" },
  ["<leader>rn"] = { vim.lsp.buf.rename, "Rename" },
  ["<leader>ca"] = { vim.lsp.buf.code_action, "Code action" },
  ["<leader>d"] = { vim.diagnostic.open_float, "Show diagnostics" },
  ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
  ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
}
