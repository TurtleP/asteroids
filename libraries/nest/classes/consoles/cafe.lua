local path = (...):gsub("%.classes.+", "")
local Vec2 = require(path .. ".classes.vec2")
local Framebuffer = require(path .. ".classes.framebuffer")
local Console = require(path .. ".classes.consoles.console")
local CAFE
local _class_0
local _parent_0 = Console
local _base_0 = {
  __getTitle = function(self)
    return self.show_gamepad and "Gamepad" or "TV"
  end,
  input = function(self, key)
    _class_0.__parent.input(self, key)
    if key == "tab" then
      self.show_gamepad = not self.show_gamepad
      if self.show_gamepad then
        self.framebuffers[1]:hide()
        self:setLayout(self:__getTitle(), self.framebuffers[2]:getSize())
        self.framebuffers[2]:show()
        return
      end
      self.framebuffers[2]:hide()
      self:setLayout(self:__getTitle(), self.framebuffers[1]:getSize())
      return self.framebuffers[1]:show()
    end
  end,
  mousepressed = function(self, x, y)
    if not self.show_gamepad then
      return
    end
    if self.touched then
      return
    end
    self.touched = true
    return love.event.push("touchpressed", 0, x, y, 0, 0, 1.0)
  end,
  mousemoved = function(self, x, y, dx, dy)
    if not self.touched then
      return
    end
    return love.event.push("touchmoved", 0, x, y, dx, dy, 1.0)
  end,
  mousereleased = function(self, x, y)
    self.touched = false
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
  __init = function(self, scale, tv_mode)
    local size = self.__class.tv_screen_sizes[tv_mode]:scale(scale)
    self:setLayout("TV", size:unpack())
    self.show_gamepad = false
    table.insert(self.framebuffers, Framebuffer("tv", Vec2:zero(), size))
    return table.insert(self.framebuffers, Framebuffer("gamepad", Vec2:zero(), self.__class.gamepad_screen_size, true))
  end,
  __base = _base_0,
  __name = "CAFE",
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
self.tv_screen_sizes = {
  ["480p"] = Vec2(854, 480),
  ["720p"] = Vec2(1280, 720),
  ["1080p"] = Vec2(1920, 1080)
}
self.gamepad_screen_size = Vec2(854, 480)
self.name = "Nintendo Wii U"
if _parent_0.__inherited then
  _parent_0.__inherited(_parent_0, _class_0)
end
CAFE = _class_0
return _class_0
