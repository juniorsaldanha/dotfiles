return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      "<leader>ce",
      "<cmd>ConformEnable<CR>",
      mode = "",
      desc = "Enable autoformat",
    },
    {
      "<leader>cd",
      "<cmd>ConformDisable<CR>",
      mode = "",
      desc = "Disable autoformat",
    },
  },
  config = function()
    require("conform").setup({
      format_on_save = function(bufnr)
        -- Don't autoformat if the buffer or global variable is set
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        go = {
          "gofumpt",
          "goimports",
        },
        python = { "black" },
        javascript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        ["_"] = { "prettier" },
      },
    })

    local usercmd = vim.api.nvim_create_user_command

    -- Disable autoformatting for a buffer or globally
    usercmd("ConformDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
      vim.notify("Autoformatting disabled", vim.log.levels.INFO, {
        title = "Conform",
      })
    end, {
      desc = "Disable autoformat G or B",
      bang = true,
    })

    -- Enable autoformatting for a buffer and globally
    usercmd("ConformEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Autoformatting enabled", vim.log.levels.INFO, {
        title = "Conform",
      })
    end, {
      desc = "Re-enable autoformat G and B",
    })
  end,
}
