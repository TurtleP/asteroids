local Vec2
local _class_0
local _base_0 = {
  zero = function()
    return Vec2(0, 0)
  end,
  unpack = function(self)
    return self.x, self.y
  end,
  scale = function(self, value)
    assert(type(value) == "number")
    self.x = self.x * value
    self.y = self.y * value
    return Vec2(self.x, self.y)
  end
}
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
_class_0 = setmetatable({
  __init = function(self, x, y)
    assert(type(x) == "number")
    assert(type(y) == "number")
    self.x = x
    self.y = y
  end,
  __base = _base_0,
  __name = "Vec2"
}, {
  __index = _base_0,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
Vec2 = _class_0
return _class_0
