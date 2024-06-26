return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "s1n7ax/nvim-window-picker",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
      config = function()
        require("telescope").setup {
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({})
            }
          }
        }
        require("telescope").load_extension("ui-select")
      end
    },
  },

  config = function(opts)
    local trouble = require("trouble.sources.telescope")
    local windowspicker = require("window-picker")
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    local newOpts = {
      defaults = {
        mappings = {
          i = {
            ["<c-t>"] = trouble.open,
          },
          n = {
            ["<c-t>"] = trouble.open,
          },
        },
        get_selection_window = function()
          local win_id = windowspicker.pick_window()
          if win_id then
            return win_id
          else
            return 0
          end
        end,
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
    }
    opts = vim.tbl_extend("force", newOpts, opts or {})

    telescope.setup(opts)

    local map = vim.keymap.set
    map("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffer" })
    map("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
    map("n", "<leader>fF", function()
      builtin.find_files({ hidden = true })
    end, { desc = "[F]ind [F]iles (hidden files)" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind using [G]rep" })
    map("n", "<leader>fG", function()
      builtin.live_grep({ hidden = true })
    end, { desc = "[F]ind using [G]rep (hidden files)" })
    map("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })
    map("n", "<leader>fT", builtin.help_tags, { desc = "[F]ind Help [T]ags" })
    map("n", "<leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
    map("n", "<leader>gS", builtin.git_stash, { desc = "[G]it [S]tash" })
    map("n", "<leader>gc", builtin.git_commits, { desc = "[G]it [C]ommits" })
    map("n", "<leader>gC", builtin.git_bcommits, { desc = "[G]it [B]ranch [C]ommits" })
    map("n", "<leader>gb", builtin.git_branches, { desc = "[G]it [B]ranches" })
    map("n", "<leader>sk", builtin.keymaps, { desc = "[S]search [K]eymaps" })
    map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    map("n", "<leader>fd", builtin.lsp_document_symbols, { desc = "[F]ind [D]ocument Symbols" })
    map("n", "<leader>fw", function()
      vim.ui.input({ prompt = "Search Symbol on Workspace: " }, function(query)
        builtin.lsp_workspace_symbols({ query = query })
      end)
    end, { desc = "[F]ind [W]orkspace Symbols" })
    map(
      "n",
      "<leader>fW",
      builtin.lsp_dynamic_workspace_symbols,
      { desc = "[F]ind [W]orkspace Symbols (dynamic)" }
    )
    map("n", "<leader>xq", builtin.quickfix, { desc = "[X] Find [Q]uickfix" })
    map("n", "<leader>xl", builtin.loclist, { desc = "[X] Find [L]oclist" })
    map("n", "<leader>xr", builtin.lsp_references, { desc = "[X] Find [R]eferences" })
    map("n", "<leader>xd", builtin.diagnostics, { desc = "[X] Find [D]iagnostics" })
  end,
}
