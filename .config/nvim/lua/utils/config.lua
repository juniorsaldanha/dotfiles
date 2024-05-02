---@class Config
---@field format_on_save boolean
local M = {}
M.__index = M

---@type boolean
M.format_on_save = true

---@type table<string, boolean>
M.format_on_save_by_buffer = {}

---@return boolean
function M.Toggle_format_on_save()
  M.format_on_save = not M.format_on_save
  return M.format_on_save
end

---@param fos boolean
function M.Set_format_on_save(fos)
  M.format_on_save = fos
end

---@return boolean
function M.Get_format_on_save()
  return M.format_on_save
end

return M
