local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local usercmd = vim.api.nvim_create_user_command -- Create user command

-- Highlight when yaking text
-- Test it with `yiw`, `yaw` or `yap` in normal mode
-- see `:h TextYankPost`

-- vim.api.nvim_create_autocmd()

autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = "400" })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})

-- Resize splits if window got resized
-- see `:h VimResized`
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
-- see `:h BufWritePre`
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Disable autoformatting for a buffer or globally
usercmd("ConformDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
  vim.notify("Autoformatting disabled", vim.log.levels.INFO, {
    title = "Conform",
  })
end, {
  desc = "Disable autoformat G or B",
  bang = true,
})

-- Enable autoformatting for a buffer and globally
usercmd("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.notify("Autoformatting enabled", vim.log.levels.INFO, {
    title = "Conform",
  })
end, {
  desc = "Re-enable autoformat G and B",
})
