---@class Config
---@field format_on_save boolean
local Config = {}
Config.__index = Config

---@type boolean
Config.format_on_save = true

---@type table<string, boolean>
Config.format_on_save_by_buffer = {}

---@return boolean
function Config:Toggle_format_on_save()
  self.format_on_save = not self.format_on_save
  return self.format_on_save
end

---@param fos boolean
function Config:Set_format_on_save(fos)
  self.format_on_save = fos
end

---@return boolean
function Config:Get_format_on_save()
  return self.format_on_save
end

return Config
