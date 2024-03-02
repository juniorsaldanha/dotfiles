return {
  "s1n7ax/nvim-window-picker",
  version = "3.*",
  config = function()
    local picker = require("window-picker")
    picker.setup({
      hint = "floating-big-letter",
      selection_char = "ASF;LKJ",
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { "NvimTree", "notify" },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { "terminal", "quickfix" },
        },
      },
    })
  end,
}
