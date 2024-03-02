return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

    local neotree = require("neo-tree")
    neotree.setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "toggleterm", "qf" },
      default_component_config = {
        indent = {
          indent_size = 1,
          padding = 1,
          with_markers = true,
          indent_marker = "|",
          last_indent_marker = "└",
        },
        icon = {
          folder_close = "",
          folder_open = "",
          folder_empty = "",
          default = "",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          default = "",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_color = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "➜",
            untracked = "",
            ignored = "ⓧ",
            unstaged = "◉",
            staged = "",
            conflict = "⚠",
          },
        },
      },
      commands = {},
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<cr>"] = "open_with_window_picker", -- this will set as default for picking a window if available
          ["<tab>"] = "open_with_window_picker",
          ["h"] = "open_with_window_picker",
          ["l"] = "open_with_window_picker",
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignore = false,
          hide_by_name = {
            "node_modules",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
    })
    vim.keymap.set(
      "n",
      "<leader>e",
      "<cmd>Neotree toggle<CR>",
      { desc = "NeoTree Toggle", noremap = true, silent = true }
    )
  end,
}
