local execute_simple_stuff = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(e)
      local lspbuf = vim.lsp.buf
      local lspdiag = vim.diagnostic
      local telescope = require("telescope.builtin")

      ---@param keys string
      ---@param func any
      ---@param desc string
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = e.buf, desc = "LSP: " .. desc })
      end

      map("gd", lspbuf.definition, "Go to definition")
      map("gr", telescope.lsp_references, "Go to references")
      map("gI", telescope.lsp_implementations, "Go to implementation")
      map("gD", telescope.lsp_type_definitions, "Go to type definition")
      map("gS", telescope.lsp_document_symbols, "Go to document symbols")
      map("gW", telescope.lsp_workspace_symbols, "Go to workspace symbols")
      map("gl", function()
        lspdiag.open_float(nil, { scope = "line" })
      end, "Go to line diagnostics")
      map("gL", function()
        telescope.diagnostics({ bufnr = 0 })
      end, "Go to buffer diagnostics")
      map("<leader>lr", function()
        vim.lsp.buf.rename()
      end, "Rename")
      map("gra", function()
        vim.lsp.buf.code_action()
      end, "Code action")
      map("K", function()
        vim.lsp.buf.hover()
      end, "Hover")
      map("<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, "Format")
    end,
  })

  -- Diagnostics
  vim.diagnostic.config({ virtual_text = { current_line = true } })
  -- Window border for hover and signature help
  vim.o.winborder = "rounded"
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-path",
      {
        "hrsh7th/cmp-nvim-lsp",
        dependencies = {
          "L3MON4D3/LuaSnip",
          -- follow latest release.
          version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
          -- install jsregexp (optional!).
          build = "make install_jsregexp"
        }
      },
      {
        "stevearc/conform.nvim",
        opts = {
          lua = { "stylua", "lua_ls" },
        },
      },
    },

    config = function()
      execute_simple_stuff()
      local mason = require("mason")
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local conform = require("conform")
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-c>"] = cmp.mapping.close(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),
          ["<C-l>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              vim.notify("Jumping forward", vim.log.levels.INFO, { title = "Luasnip" })
              luasnip.jump(1)
            else
              vim.notify("Jumping forward fallback", vim.log.levels.INFO, { title = "Luasnip" })
              fallback()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              vim.notify("Jumping back", vim.log.levels.INFO, { title = "Luasnip" })
              luasnip.jump(-1)
            else
              vim.vim.notify("jumping back fallback", vim.log.levels.INFO, { title = "Luasnip" })
              fallback()
            end
          end, { "i", "s" }),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
          { name = "path" },
          { name = "buffer" },
        }, {
          { name = "buffer" },
        }),
      })

      ---@diagnostic disable-next-line: missing-fields
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
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })

      -- Lua specific settings
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      conform.setup({
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      })
    end,
  },
}
