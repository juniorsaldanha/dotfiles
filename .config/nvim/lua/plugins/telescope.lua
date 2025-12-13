--[[
  Telescope - Fuzzy finder

  KEYMAPS: Modify the `keys` section below to change keymaps
]]

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  cmd = "Telescope",
  -- ========================================================================
  -- KEYMAPS
  -- ========================================================================
  keys = {
    -- Find
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fF", "<cmd>Telescope find_files hidden=true<CR>", desc = "Find files (hidden)" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find by grep" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Find word under cursor" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader><leader>", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },

    -- Search
    { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },
    { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Search keymaps" },
    { "<leader>sc", "<cmd>Telescope commands<CR>", desc = "Search commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "Search diagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },

    -- Git
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },

    -- LSP
    { "<leader>fd", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
    { "<leader>fW", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },

    -- Config
    {
      "<leader>ne",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Neovim config",
    },
  },
  opts = {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
          ["<C-q>"] = "send_selected_to_qflist",
          ["<Esc>"] = "close",
        },
        n = {
          ["q"] = "close",
        },
      },
    },
    pickers = {
      buffers = {
        mappings = {
          i = {
            ["<C-d>"] = "delete_buffer",
          },
          n = {
            ["<C-d>"] = "delete_buffer",
          },
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)

    -- Load fzf extension if available
    pcall(telescope.load_extension, "fzf")
  end,
}
