return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.g.fugitive_no_maps = 1
      local prefix = "[F]ugitive "
      local map = vim.keymap.set
      local opts = function(desc)
        return { noremap = true, silent = true, desc = desc }
      end
      map("n", "<leader>gfa", "<cmd>Git add %<cr>", opts(prefix .. "Add"))
      map("n", "<leader>gfA", "<cmd>Git add .<cr>", opts(prefix .. "Add all"))
      map("n", "<leader>gfc", "<cmd>Git commit<cr>", opts(prefix .. "Commit"))
      map("n", "<leader>gfC", "<cmd>Git commit --amend<cr>", opts(prefix .. "Commit (amend)"))
      map("n", "<leader>gfd", "<cmd>Git diff<cr>", opts(prefix .. "Diff"))
      map("n", "<leader>gfb", "<cmd>Git blame<cr>", opts(prefix .. "Blame"))
      map("n", "<leader>gfp", "<cmd>Git pull<cr>", opts(prefix .. "Pull"))
      map("n", "<leader>gfP", "<cmd>Git push<cr>", opts(prefix .. "Push"))
      map("n", "<leader>gfr", "<cmd>Git rebase<cr>", opts(prefix .. "Rebase"))
      map("n", "<leader>gfR", "<cmd>Git rebase --continue<cr>", opts(prefix .. "Rebase (continue)"))
      map("n", "<leader>gfs", "<cmd>Git status<cr>", opts(prefix .. "Status"))
      map("n", "<leader>gff", "<cmd>Git fetch<cr>", opts(prefix .. "Fetch"))
      map("n", "<leader>gfF", "<cmd>Git fetch --all<cr>", opts(prefix .. "Fetch (all)"))
      map("n", "<leader>gft", "<cmd>Git stash<cr>", opts(prefix .. "Stash"))
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  }
}
