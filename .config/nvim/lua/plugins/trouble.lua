local opts = function(desc)
  return { desc = desc, noremap = true, silent = true }
end

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    position = "bottom",
    mode = "workspace_diagnostics",
    height = 10,
    icons = true,
    auto_close = true, -- Auto close the trouble list when it's empty
    auto_open = false, -- Auto open the trouble list when you have a warning or error
  },
  keys = {
    { "<leader>tt", "<cmd>TroubleToggle<cr>", opts("[T]rouble [T]oggle") },
    { "<leader>tl", "<cmd>TroubleToggle loclist<cr>", opts("[T]rouble [L]oclist") },
    {
      "<leader>tw",
      "<cmd>TroubleToggle workspace_diagnostics<cr>",
      opts("[T]rouble LSP [W]orkspace Diagnostics"),
    },
    {
      "<leader>td",
      "<cmd>TroubleToggle document_diagnostics<cr>",
      opts("[T]rouble LSP [D]ocument Diagnostics"),
    },
    {
      "<leader>tr",
      "<cmd>TroubleToggle lsp_references<cr>",
      opts("[T]rouble LSP [R]eferences"),
    },
    {
      "<leader>tq",
      "<cmd>TroubleToggle quickfix<cr>",
      opts("[T]rouble [Q]uickfix"),
    },
  },
}
