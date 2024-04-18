return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            colored = true,
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            diff_color = {
              added = { fg = "#a9b665" },
              modified = { fg = "#e0af68" },
              removed = { fg = "#ea6962" },
            },
          },
          {
            "diagnostics",
            sources = { "nvim_lsp" },
          },
          "git",
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = "",
              readonly = "",
              unnamed = "",
              newfile = "",
            },
          },
        },

        lualine_x = { { "filetype", colored = true } },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
