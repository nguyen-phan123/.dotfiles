return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")

    -- Dùng mappings mặc định của Telescope, không override thêm
    telescope.setup({})

    telescope.load_extension("fzf")
  end,
}
