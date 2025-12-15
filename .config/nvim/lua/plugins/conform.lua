--[[
  Conform.nvim - Formatting

  KEYMAPS: Modify keymaps in the `keys` section below
  FORMATTERS: Add/remove formatters in the `formatters_by_ft` table
  AUTO-INSTALL: Add formatters to Mason's ensure_installed in lsp.lua
]]

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  -- ========================================================================
  -- KEYMAPS
  -- ========================================================================
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    -- ====================================================================
    -- FORMATTERS BY FILETYPE
    -- Add or modify formatters here
    -- ====================================================================
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black", "isort" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      go = { "gofmt", "goimports" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      bash = { "shfmt" },
    },

    -- ====================================================================
    -- FORMAT ON SAVE
    -- Set to false to disable auto-formatting on save
    -- ====================================================================
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },

    -- Custom formatter settings
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" }, -- 2 space indentation
      },
    },
  },
  init = function()
    -- Create format command
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })
  end,
}
