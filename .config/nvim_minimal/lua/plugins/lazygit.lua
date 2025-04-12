local map = vim.keymap.set
local opts = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

return {
  "juniorsaldanha/lazygit.nvim",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").load_extension("lazygit")
    map("n", "<leader>gl", "<cmd>LazyGit<CR>", opts("[G]it [L]azyGit"))
  end,
}
