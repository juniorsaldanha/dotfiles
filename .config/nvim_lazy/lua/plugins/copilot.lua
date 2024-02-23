return {
  "zbirenbaum/copilot.lua",
  event = { "InsertEnter" },
  -- NOTE: Load the plugin settings with delay
  config = function()
    vim.defer_fn(function()
      local copilot = require("copilot")
      copilot.setup({
        cmp = {
          enabled = true,
          method = "getCompletionsCycling",
        },
        panel = {
          enabled = false,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-y>",
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<ESC>",
            -- dismiss = "<ESC>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 16.x
        server_opts_overrides = {},
      })
    end, 200)
  end,
}
