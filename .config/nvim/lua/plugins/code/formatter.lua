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
        go = { "gofumpt", "goimports-reviser" },
        python = { "black" },
        javascript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        ["*"] = { "prettierd", "prettier" },
      },
    })
  end,
}
