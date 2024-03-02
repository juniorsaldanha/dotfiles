return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {},
  config = function()
    require("noice").setup({
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "more lines",
          },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Plugin Updates",
          },
        },
      },
      vim.keymap.set("n", "<leader>nc", "<cmd>Noice dismiss<cr>",
        { desc = "Clear notifications", noremap = true, silent = true })
    })
  end,
}
