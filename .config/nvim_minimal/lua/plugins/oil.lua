return {
  "stevearc/oil.nvim",
  version = "*",
  config = function()
    require("oil").setup({
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
    })
    local map = vim.keymap.set
    local opts = function(desc)
      return { noremap = true, silent = true, desc = desc }
    end
    map("n", "<leader>o", "<cmd>Oil<cr>", opts("Toggle Oil"))
    map("n", "<leader>-", require("oil").toggle_float, opts("Toggle Oil (float)"))
  end,
}
