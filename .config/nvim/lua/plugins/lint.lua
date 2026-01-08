--[[
  nvim-lint - Linting

  LINTERS: Add/remove linters in the `linters_by_ft` table
  AUTO-INSTALL: Add linters to Mason's ensure_installed in lsp.lua
]]

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- ====================================================================
    -- LINTERS BY FILETYPE
    -- Add or modify linters here
    -- ====================================================================
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pylint" },
      go = { "golangcilint" },
      -- Add more linters as needed
    }

    -- CUSTOM CONFIG FOR GOLANGCI-LINT
    -- By default, nvim-lint runs on the specific file.
    -- We override it to run on the directory of the current file.
    local golangcilint = lint.linters.golangcilint
    golangcilint.args = {
      "run",
      "--out-format",
      "json",
      "--show-stats=false",
      "--print-issued-lines=false",
      "--print-linter-name=false",
    }

    -- Create autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- ====================================================================
    -- KEYMAPS
    -- ====================================================================
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })
  end,
}
