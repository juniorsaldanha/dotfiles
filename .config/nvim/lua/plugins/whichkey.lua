return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    plugins = { spelling = true },
    spec = {
      {
        --     mode = { "n", "v" },
        { "<leader>b",   group = "[B]uffer" },
        { "<leader>c",   group = "[C]onform" },
        { "<leader>d",   group = "[D]AP" },
        { "<leader>d_",  hidden = true },
        { "<leader>dg",  group = "[D]AP [G]olang Test" },
        { "<leader>dg_", hidden = true },
        { "<leader>ds",  group = "[D]AP [S]teps" },
        { "<leader>ds_", hidden = true },
        { "<leader>f",   group = "[F]ind" },
        { "<leader>ft",  group = "[T]odo" },
        { "<leader>g",   group = "[G]it" },
        { "<leader>ga",  group = "[G]it-[A]ctions" },
        { "<leader>gf",  group = "[G]it-[F]ugitive" },
        { "<leader>h",   group = "[H]arpoon" },
        { "<leader>l",   group = "[L]SP" },
        { "<leader>l_",  hidden = true },
        { "<leader>n",   group = "[N]oice" },
        { "<leader>o",   group = "[O]il" },
        { "<leader>s",   group = "[S]earch" },
        { "<leader>t",   group = "[T]odo" },
        { "<leader>u_",  hidden = true },
        { "<leader>x",   group = "[X] Diagnostics" },
        { "<leader>z",   group = "[Z] Zen" },
      },
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
