return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      -- Dùng cấu hình mặc định
    })

    -- Cú pháp MỚI (v3) giúp tắt cảnh báo trong ảnh
    wk.add({
      { "<leader>b", group = "buffer" },     -- Nhóm buffer
      { "<leader>f", group = "file/find" },  -- Nhóm file
      { "<leader>g", group = "git" },        -- Nhóm git
      { "<leader>l", group = "lsp/code" },   -- Nhóm lsp
      { "<leader>q", group = "quit" },       -- Nhóm quit
      { "<leader>s", group = "search" },     -- Nhóm search
      { "<leader>t", group = "toggle" },     -- Nhóm toggle
      { "<leader>w", group = "window" },     -- Nhóm window
    })
  end,
}