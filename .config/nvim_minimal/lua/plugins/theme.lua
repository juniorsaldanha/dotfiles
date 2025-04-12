return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("tokyonight").setup(opts) -- calling setup is optional
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
