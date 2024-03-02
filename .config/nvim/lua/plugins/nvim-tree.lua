if true then
  return {}
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "1.0",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- local nvim_tree_api = require("nvim-tree.api")
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 40,
        side = "left",
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
      },
      filters = {
        dotfiles = true,
      },
    })

    vim.keymap.set(
      "n",
      "<leader>e",
      "<cmd>NvimTreeToggle<CR>",
      { desc = "NvimTree Toggle", noremap = true, silent = true }
    )
  end,
}
