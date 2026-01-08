return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      options = {
        number = true,
        relativenumber = true,
      },
    },
    plugins = {
      gitsigns = true,
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },
}
