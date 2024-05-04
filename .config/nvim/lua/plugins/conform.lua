local config = require("utils.config")
local M = {}

-- Needs to implement a custom data for the buffer and global variable to maintain the state
M.format_on_save_toggle = function(opts)
  if opts.fargs[1] == "buffer" then
    -- Buffer
    ---@diagnostic disable-next-line: inject-field
    vim.b.disable_autoformat = config.Get_format_on_save()
  elseif opts.fargs[1] == "global" or opts.fargs[1] == nil then
    -- Global
    vim.g.disable_autoformat = config.Get_format_on_save()
    ---@diagnostic disable-next-line: inject-field
    vim.b.disable_autoformat = config.Get_format_on_save()
  end

  vim.notify(
    "Autoformatting "
    .. (not config.Get_format_on_save() and "Enabled" or "Disabled")
    .. (opts.fargs[1] == "buffer" and " on this Buffer" or " Globally"),
    vim.log.levels.INFO,
    { title = "Autoformatting Toggle" }
  )
  config.Toggle_format_on_save()
end

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
      desc = "[F]ormat with Conform",
    },
    {
      "<leader>ct",
      "<cmd>FormatOnSaveToggle<cr>",
      desc = "[T]oggle Format On Save",
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

    usercmd("FormatOnSaveToggle", M.format_on_save_toggle, {
      desc = "Toggle autoformat on save",
      nargs = "?",
    })
  end,
}
