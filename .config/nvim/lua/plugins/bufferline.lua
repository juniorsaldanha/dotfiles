return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    {
      "n",
      "<leader>bC",
      function()
        local buffers = vim.api.nvim_list_buffers()
        local pinned = vim.fn.map(vim.fn.filter(buffers, "getbufvar(v:val, '&mfb') == 1"), "bufnr(v:val)")
        for _, buffer in ipairs(buffers) do
          local bufnr = buffer
          if not vim.tbl_contains(pinned, bufnr) then
            vim.api.nvim_command("bdelete " .. bufnr)
          end
        end
      end,
      { noremap = true, silent = true, desc = "Close all buffers" },
    },
  },
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal",
        buffer_close_icon = "",
        indicator = {
          icon = " ",
          style = "icon",
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or ""
          return " " .. icon .. count
        end,
        max_name_length = 24,
        color_icon = true,
        separator_style = "thin",
        offsets = {
          {
            filetype = "Neotree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })
    vim.keymap.set("n", "<leader>bC", function()
      local buffers = vim.api.nvim_list_bufs()
      local all_pinned = vim.fn.map(vim.fn.filter(buffers, "getbufvar(v:val, '&mfb') == 1"), "bufnr(v:val)")
      -- inspect table
      print(vim.inspect(buffers), buffers, vim.inspect(all_pinned), all_pinned)
      -- for _, buffer in ipairs(buffers) do
      --   local bufnr = buffer
      --   if not vim.tbl_contains(pinned, bufnr) then
      --     vim.api.nvim_command("bdelete " .. bufnr)
      --   end
      -- end
    end, { noremap = true, silent = true, desc = "Close all buffers not pinned" })
  end,
}
