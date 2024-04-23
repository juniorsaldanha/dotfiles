return {
  "s1n7ax/nvim-window-picker",
  version = "3.*",
  config = function()
    local picker = require("window-picker")
    picker.setup({
      hint = "floating-big-letter",
      show_prompt = false,
      selection_char = "ASF;LKJ",
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = {
            "Trouble",
            "notify",
            "noice",
            "nofile",
            "TelescopeResults",
            "TelescopePrompt",
            "oil",
            "lazygit",
          },
          -- if the buffer type is one of following, the window will be ignored
          buftype = {
            "terminal",
            "quickfix",
            "nofile",
            "prompt",
            "acwrite",
          },
        },
      },
    })
  end,
}
