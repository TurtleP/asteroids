local path = (...):gsub("%.classes.+", "")
local Vec2 = require(path .. ".classes.vec2")
local Framebuffer = require(path .. ".classes.framebuffer")
local Console = require(path .. ".classes.consoles.console")
local CTR
local _class_0
local _parent_0 = Console
local _base_0 = {
  __inside = function(self, x, y)
    return (x >= 40 and x <= 360) and y >= 240
  end,
  __clamp = function(self, value, max)
    return math.max(0, math.min(value, max))
  end,
  mousepressed = function(self, x, y)
    if not self:__inside(x, y) or self.touched then
      return
    end
    self.touched = true
    x = self:__clamp(x - 40, 320)
    y = self:__clamp(y - 240, 240)
    return love.event.push("touchpressed", 0, x, y, 0, 0, 1.0)
  end,
  mousemoved = function(self, x, y, dx, dy)
    if not self.touched then
      return
    end
    x = self:__clamp(x - 40, 320)
    y = self:__clamp(y - 240, 240)
    return love.event.push("touchmoved", 0, x, y, dx, dy, 1.0)
  end,
  mousereleased = function(self, x, y)
    self.touched = false
    x = self:__clamp(x - 40, 320)
    y = self:__clamp(y - 240, 240)
    return love.event.push("touchreleased", 0, x, y, 0, 0, 0.0)
  end
}
for _key_0, _val_0 in pairs(_parent_0.__base) do
  if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
    _base_0[_key_0] = _val_0
  end
end
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
  __init = function(self, scale)
    _class_0.__parent.__init(self, self.__class.screen_size:scale(scale):unpack())
    table.insert(self.framebuffers, Framebuffer("left", Vec2:zero(), self.__class.top_screen_size:scale(scale)))
    table.insert(self.framebuffers, Framebuffer("right", Vec2:zero(), self.__class.top_screen_size:scale(scale)))
    return table.insert(self.framebuffers, Framebuffer("bottom", Vec2(40, 240), self.__class.bottom_screen_size:scale(scale)))
  end,
  __base = _base_0,
  __name = "CTR",
  __parent = _parent_0
}, {
  __index = function(cls, name)
    local val = rawget(_base_0, name)
    if val == nil then
      local parent = rawget(cls, "__parent")
      if parent then
        return parent[name]
      end
    else
      return val
    end
  end,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
local self = _class_0;
self.screen_size = Vec2(400, 480)
self.top_screen_size = Vec2(400, 240)
self.bottom_screen_size = Vec2(320, 240)
self.name = "Nintendo 3DS"
if _parent_0.__inherited then
  _parent_0.__inherited(_parent_0, _class_0)
end
CTR = _class_0
return _class_0
