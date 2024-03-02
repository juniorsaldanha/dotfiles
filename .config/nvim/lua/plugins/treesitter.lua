return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      context_commentstring = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
      },
      refactor = {
        highlight_definitions = {
          enable = true,
        },
      },
      textobjects = {
        select = {
          enable = true,
        },
      },
    }
  end,
}
