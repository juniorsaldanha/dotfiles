return {
  "stevearc/oil.nvim",
  version = "*",
  opts = {
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
  },
  keys = {
    {
      "<leader>o",
      function()
        vim.cmd("Oil")
      end,
      { desc = "Toggle Oil", nowait = true, noremap = true },
    },
  },
}
