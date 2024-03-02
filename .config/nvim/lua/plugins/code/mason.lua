return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    {
      "williamboman/mason.nvim",
      keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },
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
        ensure_installed = {
          "lua_ls",
          "gopls",
          "yamlls",
          "jsonls",
          "pyright",
          "clangd",
          "dockerls",
          "docker_compose_language_service",
          "bashls",
          "marksman",
        },
      },
      config = function(_, opts)
        require("mason").setup(opts)
      end,
    },
  },
  opts = {
    automatic_installation = true,
  },
  config = function()
    local lspconfig = require("lspconfig")
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    local default_setup = function(server)
      require("lspconfig")[server].setup({
        capabilities = lsp_capabilities,
      })
    end

    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "gopls",
        "yamlls",
        "jsonls",
        "pyright",
        "clangd",
        "dockerls",
        "docker_compose_language_service",
        "bashls",
        "marksman",
      },
      handlers = {
        default_setup,
        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = lsp_capabilities,
            settings = {
              Lua = {
                completation = {
                  callSnippet = "Replace",
                },
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },
              },
            },
          })
        end,
        gopls = function()
          lspconfig.gopls.setup({
            capabilities = lsp_capabilities,
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
                analyses = {
                  fieldalignment = true,
                  nilness = true,
                  unusedparams = true,
                  unusedwrite = true,
                  useany = true,
                },
                codelenses = {
                  tidy = true,
                  test = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
                staticcheck = true,
                gofumpt = true,
                usePlaceholders = true,
                completeUnimported = true,
              },
            },
          })
        end,
      },
    })
  end,
}
