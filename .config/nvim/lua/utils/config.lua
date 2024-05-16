---@class Config
---@field format_on_save boolean
---@field transpatent boolean
local M = {}
M.__index = M

---@type boolean
M.format_on_save = true

---@type boolean
M.transparent = false

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

---@return boolean
function M.Toggle_transparent()
  M.transparent = not M.transparent
  return M.transparent
end

---@return boolean
function M.Get_transparent()
  return M.transparent
end

return M
