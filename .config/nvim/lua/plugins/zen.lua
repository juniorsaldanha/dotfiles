return {
  "folke/zen-mode.nvim",
  opts = {
    alacritty = {
      enable = true,
    },
  },
  keys = {
    {
      "<leader>zz",
      "<cmd>ZenMode<cr>",
      { desc = "ZenMode toggle", noremap = true, silent = true },
    },
  },
}
