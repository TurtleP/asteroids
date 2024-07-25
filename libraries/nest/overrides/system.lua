local path
path = (...):gsub("%.overrides.+", "")
local config = require(path .. ".config")
local Timer = require(path .. ".classes.timer")
local hook = require(path .. ".libraries.hook")
local battery_level = 100
local battery_status = "battery"
local battery_plugged_in = false
love.system.getOS = function()
  return love._os
end
love.system.getPowerInfo = function()
  if battery_level == 100 and battery_plugged_in then
    battery_status = "charged"
  end
  return battery_status, battery_level
end
local https
https = require("https")
love.system.getWifiStatus = function()
  local code, _ = https.request("https://example.com")
  local status = code == 200 and "connected" or "disconnected"
  local strength = code == 200 and 1 or 0
  return status, strength
end
love.system._plugInCharger = function(plugged_in)
  battery_plugged_in = plugged_in
  if plugged_in then
    battery_status = "charging"
    return
  end
  battery_status = "battery"
end
love.system._toggleCharger = function()
  return love.system._plugInCharger(not battery_plugged_in)
end
local _updateBattery
_updateBattery = function(value)
  battery_level = math.max(0, math.min(battery_level + value, 100))
end
local _battery_timer
_battery_timer = function(progress, self)
  local value = battery_plugged_in and 1 or -1
  _updateBattery(value)
  return self:reset()
end
local battery_timer = Timer(60, nil, _battery_timer)
return hook.add("update", {
  function(dt)
    return battery_timer:update(dt)
  end
})
