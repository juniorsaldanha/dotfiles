--[[
  LSP Configuration
  - mason.nvim: Package manager for LSP servers, linters, formatters
  - mason-lspconfig: Bridge between mason and lspconfig
  - nvim-lspconfig: LSP client configuration

  KEYMAPS: Modify the `on_attach` function below to change LSP keymaps
  SERVERS: Add/remove servers in the `servers` table below
]]

return {
  -- Mason: Package manager for LSP servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-LSPConfig: Auto-install LSP servers
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- ============================================================
      -- LSP SERVERS TO AUTO-INSTALL
      -- Add or remove servers here
      -- ============================================================
      ensure_installed = {
        "lua_ls", -- Lua
        "ts_ls", -- TypeScript/JavaScript
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "pyright", -- Python
        "gopls", -- Go
        "rust_analyzer", -- Rust
        "bashls", -- Bash
        "yamlls", -- YAML
      },
      automatic_installation = true,
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- ============================================================
      -- LSP KEYMAPS
      -- Modify these keymaps to your preference
      -- ============================================================
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- Navigation
        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("gr", vim.lsp.buf.references, "Goto References")
        map("gI", vim.lsp.buf.implementation, "Goto Implementation")
        map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")

        -- Documentation
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

        -- Actions
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

        -- Diagnostics
        map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")

        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider then
          map("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
          end, "Toggle Inlay Hints")
        end
      end

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- Set diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Default capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Add cmp capabilities if available
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- ============================================================
      -- SERVER CONFIGURATIONS
      -- Add custom server settings here
      -- ============================================================
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- Tell the language server which version of Lua you're using
              runtime = { version = "LuaJIT" },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add specific plugins here too
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                },
              },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        ts_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        pyright = {},
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        rust_analyzer = {},
        bashls = {},
        yamlls = {},
      }

      -- Setup all servers
      local lspconfig = require("lspconfig")
      for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },
}
