return {
  "folke/persistence.nvim",
  lazy = false,
  config = function()
    require("persistence").setup({
      dir = vim.fn.stdpath("data") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize" },
    })
  end,
}
