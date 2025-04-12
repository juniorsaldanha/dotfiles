return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
        },
      },
      {
        "stevearc/conform.nvim",
        opts = {
          lua = { "stylua", "lua_ls" },
        },
      },
    },

    config = function()
      local mason = require("mason")
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local conform = require("conform")

      mason.setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        automatic_installation = true,
        ensure_installed = {
          "lua_ls",
          "clangd",
          "pyright",
          "gopls",
          "rust_analyzer",
          "jsonls",
        },
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
      })

      conform.setup({
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      })
      vim.diagnostic.config({ virtual_text = { current_line = true } })
      vim.o.winborder = "single"
    end,
  },
}
