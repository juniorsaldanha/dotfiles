return {
  "nvim-telescope/telescope.nvim",
  version = false,
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
  },
  keys = {
    {
      "<leader>ff",
      "<cmd>lua require('telescope.builtin').find_files({ hidden = false })<cr>",
      desc = "[F]ind [f]iles (no hidden)",
    },
    {
      "<leader>fF",
      "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<cr>",
      desc = "[F]ind [F]iles (hidden)",
    },
    {
      "<leader>fg",
      "<cmd>lua require('telescope.builtin').live_grep()<cr>",
      desc = "[F]ind using [G]rep",
    },
    {
      "<leader>fb",
      "<cmd>lua require('telescope.builtin').buffers()<cr>",
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader><leader>",
      "<cmd>lua require('telescope.builtin').buffers()<cr>",
      desc = "Find Buffer",
    },
    {
      "<leader>fh",
      "<cmd>lua require('telescope.builtin').help_tags()<cr>",
      desc = "[F]ind [H]elp Tags",
    },
    {
      "<leader>fk",
      "<cmd>lua require('telescope.builtin').keymaps()<cr>",
      desc = "[F]ind [K]eymaps",
    },
    {
      "<leader>ds",
      "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
      desc = "[D]ocument [S]ymbols",
    },
    {
      "<leader>fS",
      "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>",
      desc = "[W]orkspace [S]ymbols",
    },
    {
      "<leader>gs",
      "<cmd>lua require('telescope.builtin').git_status()<cr>",
      desc = "[G]it [S]tatus",
    },
    {
      "<leader>gS",
      "<cmd>lua require('telescope.builtin').git_stash()<cr>",
      desc = "[G]it [S]tash",
    },
    {
      "<leader>gc",
      "<cmd>lua require('telescope.builtin').git_commits()<cr>",
      desc = "[G]it [C]ommits",
    },
    {
      "<leader>gb",
      "<cmd>lua require('telescope.builtin').git_branches()<cr>",
      desc = "[G]it [B]ranches",
    },
    {
      "<leader>gac",
      "<cmd>lua require('telescope.builtin').actions.git_checkout()<cr>",
      desc = "[G]it [A]ctions [C]heckout",
    },
    {
      "<leader>gas",
      "<cmd>lua require('telescope.builtin').actions.git_apply_stash()<cr>",
      desc = "[G]it [A]ctions [S]tash",
    },
    {
      "<leader>gaB",
      "<cmd>lua require('telescope.builtin').actions.git_create_branch()<cr>",
      desc = "[G]it [A]ctions [B]ranch",
    },
    {
      "<leader>gasb",
      "<cmd>lua require('telescope.builtin').actions.git_switch_branch()<cr>",
      desc = "[G]it [A]ctions [S]witch [B]ranch",
    },
    {
      "<leader>garb",
      "<cmd>lua require('telescope.builtin').actions.git_rename_branch()<cr>",
      desc = "[G]it [A]ctions [R]ename [B]ranch",
    },
    {
      "<leader>sh",
      "<cmd>lua require('telescope.builtin').help_tags()<cr>",
      desc = "[S]earch [H]elp",
    },

  },
  config = function()
    require("telescope").setup({
      pickers = {
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    })
  end,
}
