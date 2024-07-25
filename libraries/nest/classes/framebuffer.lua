local path = (...):gsub("%.classes.+", "")
require(path .. ".overrides.graphics")
local Framebuffer
local _class_0
local _base_0 = {
  getDepth = function(self)
    local depth = love.graphics.getDepth()
    if self.name == "right" then
      depth = -depth
    else
      depth = 0
    end
    return depth
  end,
  draw = function(self)
    love.graphics.setActiveScreen(self)
    self.canvas:renderTo(function()
      love.graphics.clear(love.graphics.getBackgroundColor())
      if love.draw then
        return love.draw(self.name, self:getDepth())
      end
    end)
    if self.hidden then
      return
    end
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.canvas, self.position:unpack())
    return love.graphics.setColor(1, 1, 1, 1)
  end,
  hide = function(self)
    self.hidden = true
  end,
  show = function(self)
    self.hidden = false
  end,
  getWidth = function(self)
    return self.size.x
  end,
  getHeight = function(self)
    return self.size.y
  end,
  getSize = function(self)
    return self.size:unpack()
  end,
  getName = function(self)
    return self.name
  end
}
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
_class_0 = setmetatable({
  __init = function(self, name, position, size, hidden)
    self.name = name
    self.position = position
    self.size = size
    self.hidden = hidden
    self.canvas = love.graphics.newCanvas(size:unpack())
    self.alpha = self.name ~= "right" and 1 or 0.75
  end,
  __base = _base_0,
  __name = "Framebuffer"
}, {
  __index = _base_0,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
Framebuffer = _class_0
return _class_0
