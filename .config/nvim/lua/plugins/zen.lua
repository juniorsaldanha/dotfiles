local M = {}
M.zenmode_enabled = false

local km = vim.keymap

return {
  "folke/zen-mode.nvim",
  opts = {
    alacritty = {
      enable = true,
    },
  },
  config = function()
    require("zen-mode").setup({
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = true,
          relativenumber = true,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        twilight = { enabled = false },
      },
      on_open = function()
        vim.cmd("set foldlevel=20")
      end,
      on_close = function()
        vim.cmd("set foldlevel=0")
      end,
    })
    km.set("n", "<leader>z", function()
      require("zen-mode").toggle()
      if M.zenmode_enabled then
        M.zenmode_enabled = false

        vim.cmd("Lazy reload vim-tmux-navigator")
      else
        M.zenmode_enabled = true

        km.del("n", "<c-h>")
        km.del("n", "<c-j>")
        km.del("n", "<c-k>")
        km.del("n", "<c-l>")
      end
    end, { desc = "ZenMode Toggle" })
  end,
}
