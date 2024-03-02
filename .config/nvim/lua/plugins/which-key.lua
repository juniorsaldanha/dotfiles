return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      -- ["g"] = { name = "+goto" },
      ["gs"] = { name = "+surround" },
      -- ["]"] = { name = "+next" },
      -- ["["] = { name = "+prev" },
      -- ["<leader><tab>"] = { name = "+tabs" },
      ["<leader>b"] = { name = "+buffer" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader>ft"] = { name = "+todo" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>ga"] = { name = "+git-actions" },
      -- ["<leader>gh"] = { name = "+hunks" },
      -- ["<leader>q"] = { name = "+quit/session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>lg"] = { name = "+lazygit" },
      -- ["<leader>u"] = { name = "+ui" },
      -- ["<leader>w"] = { name = "+windows" },
      -- ["<leader>x"] = { name = "+diagnostics/quickfix" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    -- local presets = require("which-key.plugins.presets")
    wk.setup(opts)
    wk.register(opts.defaults)
    -- for 1-9 nil all the key <leader>1-9
    -- for i = 1, 9 do
    --   presets.operator["<leader>" .. i] = nil
    -- end
  end,
}
