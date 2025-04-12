return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<leader>nc", "<cmd>Noice dismiss<cr>", desc = "[N]oice [D]ismiss" },
    { "<leader>nh", "<cmd>Noice history<cr>", desc = "[N]oice [H]istory" },
    { "<leader>nt", "<cmd>NoiceTelescope<cr>", desc = "[N]oice [T]elescope" },
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Pick window",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "window",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "lazy",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "nvim_win_close",
            find = "",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "more lines",
            find = "more lines",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "Plugin Updates",
            find = "Plugin Updates",
          },
          opts = { skip = true },
        },
      },
    })
  end,
}
