return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    "s1n7ax/nvim-window-picker",
  },

  opts = {
    defaults = {
      -- TODO: Develop a way to delete buffer from the telescope buffer list <leader><leader> keymap
      -- mapping = {
      --     n = {
      --         ["<C-d>"] = require("telescope.actions").delete_buffer,
      --     },
      --     i = {
      --         ["<C-h>"] = "which_key",
      --         ["<C-d>"] = require("telescope.actions").delete_buffer,
      --     },
      -- },
      get_selection_window = function()
        local win_id = require("window-picker").pick_window()
        if win_id then
          return win_id
        else
          return 0
        end
      end,
    },
  },

  config = function(opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    local map = vim.keymap.set
    local builtin = require("telescope.builtin")
    map("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    map("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles (no hidden)" })
    map("n", "<leader>fF", builtin.find_files, { desc = "[F]ind [F]iles (hidden)" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind using [G]rep" })
    map("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    map("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffer" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp Tags" })
    map("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
    map("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
    map("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
    map("n", "<leader>gS", builtin.git_stash, { desc = "[G]it [S]tash" })
    map("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })
    map("n", "<leader>gC", builtin.git_bcommits, { desc = "[G]it [B]ranch [C]ommits" })
    map("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [B]ranches" })
    map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  end,
}
