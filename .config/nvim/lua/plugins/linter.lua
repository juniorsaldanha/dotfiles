return {
  "mfussenegger/nvim-lint",
  events = {
    "BufWritePost",
    "BufReadPost",
    "BufNewFile",
    "InsertLeave",
  },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      lua = { "luacheck" },
      go = { "golangcilint" },
      -- go = { "sonarlint-language-server" },
      zsh = { "zsh" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
    },
    ---@type table<string,table>
    linters = {},
  },
  config = function(_, opts)
    local M = {}

    local lint = require("lint")
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        ---@diagnostic disable-next-line: param-type-mismatch
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    -- golangcilint v2 compatible, v1 is deprecated
    lint.linters.golangcilint.args = {
      "run",
      "--output.json.path=stdout",
      "--issues-exit-code=0",
      "--show-stats=false",
      "--output.text.print-issued-lines=false",
      "--output.text.print-linter-name=false",
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      end,
    }

    lint.linters.sonarlint_language_server = {
      cmd = "sonarlint-language-server",
      stdin = true,
      args = { "--stdio" },
      stream = "stdout",
      name = "sonarlint-language-server",
      parser = function(output, _)
        if output == "" then
          return {}
        end
        local diagnostics = {}
        for _, line in ipairs(vim.split(output, "\n")) do
          local parts = vim.split(line, "\t")
          if #parts == 4 then
            local row = tonumber(parts[2]) - 1
            local col = tonumber(parts[3]) - 1
            local message = parts[4]
            table.insert(diagnostics, {
              source = "sonarlint",
              range = {
                ["start"] = { line = row, character = col },
                ["end"] = { line = row, character = col },
              },
              message = message,
              severity = 1,
            })
          end
        end
        return diagnostics
      end,
    }

    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.lint()
      -- Resolve linters.
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
        else
          if name == "luacheck" then
            -- add global `vim`, `it`, `describe`, `before_each`, `after_each` to luacheck globals
            linter.args = { "--globals", "vim", "it", "describe", "before_each", "after_each" }
          end
          -- vim.notify("Linter found: " .. name, vim.log.levels.INFO, { title = "nvim-lint" })
          -- vim.notify("Linter: " .. vim.inspect(linter), vim.log.levels.INFO, { title = "nvim-lint" })
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      -- Run linters.
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(100, M.lint),
    })
  end,
}
