local M = {}

M.check_version = function()
  local verstr =
    string.format("%s.%s.%s", vim.version().major, vim.version().minor, vim.version().patch)
  if not vim.version.cmp then
    vim.health.error(
      string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr)
    )
    return
  end

  if vim.version.cmp(vim.version(), { 0, 9, 4 }) >= 0 then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(
      string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr)
    )
  end
end

M.check_external_reqs = function()
  local basic_utils = {
    "git",
    "make",
    "unzip",
    "rg",
    "fzf",
    "lazygit",
    "cargo",
    "asdf",
  }

  -- check if each of the basic utils are installed
  for _, exe in ipairs(basic_utils) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

M.check = function()
  vim.health.start("umsaldanha.nvim")

  vim.health.info("[[NOTE: Not every warning is a 'must-fix' in `:checkhealth`]]")

  local uv = vim.uv or vim.loop
  vim.health.info("System Information: " .. vim.inspect(uv.os_uname()))

  M.check_version()
  M.check_external_reqs()
end

return M
