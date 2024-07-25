local Console
local _class_0
local _base_0 = {
  framebuffers = { },
  render = function(self)
    love.graphics.push()
    local _list_0 = self.framebuffers
    for _index_0 = 1, #_list_0 do
      local framebuffer = _list_0[_index_0]
      framebuffer:draw()
    end
    return love.graphics.pop()
  end,
  setLayout = function(self, title, width, height)
    love.window.updateMode(width, height)
    local title_case = title:sub(1, 1):upper() .. title:sub(2)
    return love.window.setTitle(tostring(self.__class.name) .. " (" .. tostring(title_case) .. " View)")
  end,
  input = function(self, key)
    if key == "`" then
      return love.system._toggleCharger()
    end
  end,
  mousepressed = function(self, x, y)
    return
  end,
  mousemoved = function(self, x, y, dx, dy)
    return
  end,
  mousereleased = function(self, x, y)
    return
  end
}
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
_class_0 = setmetatable({
  __init = function(self, width, height)
    love.window.updateMode(width, height)
    love.window.setTitle(self.__class.name)
    self.touched = false
  end,
  __base = _base_0,
  __name = "Console"
}, {
  __index = _base_0,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
Console = _class_0
return _class_0
