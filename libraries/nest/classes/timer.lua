local Timer
local _class_0
local _base_0 = {
  update = function(self, dt)
    if not self:expired() then
      self.timer = self.timer + dt
      self.has_expired = self.timer >= self.time
      local callback = self:expired() and self.on_finish or self.on_progress
      if callback then
        return callback(self:progress(), self)
      end
    end
  end,
  expired = function(self)
    return self.has_expired
  end,
  progress = function(self)
    return math.min(self.timer / self.time, 1)
  end,
  reset = function(self, time)
    self.timer = 0
    self.time = math.max(time or self.time, 1e-6)
    self.has_expired = false
    return self
  end
}
if _base_0.__index == nil then
  _base_0.__index = _base_0
end
_class_0 = setmetatable({
  __init = function(self, time, on_progress, on_finish)
    self.time = time
    self.on_progress = on_progress
    self.on_finish = on_finish
    return self:reset(time)
  end,
  __base = _base_0,
  __name = "Timer"
}, {
  __index = _base_0,
  __call = function(cls, ...)
    local _self_0 = setmetatable({ }, _base_0)
    cls.__init(_self_0, ...)
    return _self_0
  end
})
_base_0.__class = _class_0
Timer = _class_0
return _class_0
