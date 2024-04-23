return {
  "akinsho/flutter-tools.nvim",
  ft = "dart",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("telescope").load_extension("flutter")
    require("flutter-tools").setup({})
    vim.notify("Flutter Tools Enabled", vim.log.levels.INFO, { title = "flutter-tools.nvim" })

    local opts = function(description)
      return { noremap = true, silent = true, desc = description }
    end

    vim.keymap.set(
      "n",
      "<leader>Fs",
      "<cmd>!open -a Simulator<cr>",
      opts("Open iPhone 15 Pro Simulator")
    )
    vim.keymap.set(
      "n",
      "<leader>Fc",
      "<cmd>Telescope flutter commands<cr>",
      opts("Flutter Commands")
    )
  end,
}
