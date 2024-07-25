local path
path = (...):gsub("%.overrides.+", "")
local config = require(path .. ".config")
love._potion_version = "3.0.0"
love._potion_version_major = "3"
love._potion_version_minor = "0"
love._potion_version_revision = "0"
local _exp_0 = config.get("console")
if Console.NINTENDO_3DS == _exp_0 then
  love._os = "Horizon"
elseif Console.NINTENDO_SWITCH == _exp_0 then
  love._os = "Horizon"
else
  love._os = "Cafe"
end
