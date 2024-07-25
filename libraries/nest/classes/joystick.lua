local path = (...):gsub("%.classes.+", "")
local mappings = require(path .. ".mappings")
local Joystick
local _class_0
local _base_0 = {
  __parseSource = function(self, source)
    return source:match("(.+):(.+)")
  end,
  __parseAxis = function(self, value)
    return value:match('(.+)([%+%-])')
  end,
  update = function(self)
    for axis, value in pairs(self.axis_events) do
      love.gamepadaxis(self, axis, value)
    end
  end,
  keypressed = function(self, key)
    if not mappings[key] then
      return
    end
    local source, button = self:__parseSource(mappings[key])
    if source == "axis" then
      local value, direction = self:__parseAxis(button)
      self.axis_events[value] = direction == "-" and -1 or 1
      return
    end
    return love.event.push("gamepadpressed", self, button)
  end,
  keyreleased = function(self, key)
    if not mappings[key] then
      return
    end
    local source, button = self:__parseSource(mappings[key])
    if source == "axis" then
      local value, direction = self:__parseAxis(button)
      self.axis_events[value] = nil
      love.gamepadaxis(self, value, 0)
      return
    end
    return love.event.push("gamepadreleased", self, button)
  end
}
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
_class_0 = setmetatable({
  __init = function(self)
    -- { { event = "gamepadaxis", params = ... } }
    self.axis_events = { }
  end,
  __base = _base_0,
  __name = "Joystick"
}, {
  __index = _base_0,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
local self = _class_0;
self.id = 0
Joystick = _class_0
return _class_0
