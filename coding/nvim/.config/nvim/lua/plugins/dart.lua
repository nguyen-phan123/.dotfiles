return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      local function get_fvm_flutter_sdk()
        -- Check for local fvm flutter_sdk symlink
        local fvm_flutter_sdk = vim.fn.getcwd() .. "/.fvm/flutter_sdk"
        if vim.fn.isdirectory(fvm_flutter_sdk) == 1 then
          return fvm_flutter_sdk
        end
        -- Fall back to global fvm if available
        return nil
      end

      local flutter_sdk = get_fvm_flutter_sdk()
      local flutter_path = flutter_sdk and (flutter_sdk .. "/bin/flutter") or "flutter"
      local dart_path = flutter_sdk and (flutter_sdk .. "/bin/dart") or "dart"

      require("flutter-tools").setup({
        flutter_path = flutter_path,
        flutter_lookup_cmd = nil, -- Use flutter_path instead
        fvm = true, -- Enable fvm support
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
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local keymap = vim.keymap

            -- Flutter specific keymaps
            keymap.set("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run", buffer = bufnr })
            keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter Quit", buffer = bufnr })
            keymap.set("n", "<leader>fd", "<cmd>FlutterDevices<cr>", { desc = "Flutter Devices", buffer = bufnr })
            keymap.set("n", "<leader>fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter Emulators", buffer = bufnr })
            keymap.set("n", "<leader>fr", "<cmd>FlutterReload<cr>", { desc = "Flutter Reload", buffer = bufnr })
            keymap.set("n", "<leader>fR", "<cmd>FlutterRestart<cr>", { desc = "Flutter Restart", buffer = bufnr })
            keymap.set("n", "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter Outline", buffer = bufnr })

            -- Standard LSP keybindings
            keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            keymap.set("n", "gr", vim.lsp.buf.references, opts)
            keymap.set("n", "K", vim.lsp.buf.hover, opts)
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
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
