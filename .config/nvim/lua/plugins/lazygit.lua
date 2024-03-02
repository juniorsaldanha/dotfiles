return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>lg",
      "<cmd>LazyGit<CR>",
      { desc = "LazyGit" },
    },
  },
}
