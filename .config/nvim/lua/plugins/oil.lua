--[[
  Oil.nvim - File explorer

  KEYMAPS: Modify keymaps in the `keys` section
]]

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- ========================================================================
  -- KEYMAPS
  -- ========================================================================
  keys = {
    { "<leader>o", "<cmd>Oil<cr>", desc = "Toggle Oil" },
  },
  opts = {
    columns = { "icon" },
    view_options = {
      show_hidden = true,
    },
  },
}
