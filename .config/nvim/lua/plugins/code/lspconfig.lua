-- WARN: TO REMOVE ON FUTURE, CHECK IT OUT mason.lua everyting is there
if true == true then
  return {}
end

local k = vim.keymap
local opts = function(desc)
  return { desc = desc, silent = true, nowait = true }
end

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    { "hrsh7th/nvim-cmp", opts = {} },
    { "hrsh7th/cmp-nvim-lsp", opts = {} },
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
        },
      },
    })

    lspconfig.gopls.setup({
      capabilities = capabilities,
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

    lspconfig.pyright.setup({
      capabilities = capabilities,
    })

    lspconfig.neocmake.setup({
      capabilities = capabilities,
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
    })

    -- Keybindings to lsp
    k.set("n", "K", ":lua vim.lsp.buf.hover()<cr>", opts("Hover"))
    k.set("n", "gd", ":lua require('telescope.builtin').lsp_definitions()<cr>", opts("Go to Definition"))
    k.set("n", "gD", ":lua require('telescope.builtin').lsp_declarations()<cr>", opts("Go to Declaration"))
    k.set("n", "gr", ":lua require('telescope.builtin').lsp_references()<cr>", opts("Go to References"))
    k.set("n", "gi", ":lua require('telescope.builtin').lsp_implementations()<cr>", opts("Go to Implementation"))
    k.set("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<cr>", opts("Signature Help"))
    k.set("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<cr>", opts("Go to Previous Diagnostic"))
    k.set("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<cr>", opts("Go to Next Diagnostic"))
    k.set("n", "<leader>cr", ":lua vim.lsp.buf.rename()<cr>", opts("Rename"))
    k.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", opts("Code Action"))
    k.set("n", "<leader>cs", ":lua vim.lsp.diagnostic.set_loclist()<cr>", opts("Set Location List"))
  end,
}
