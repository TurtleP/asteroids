local explosion = class()

explosion._max_time = 2

function explosion:new(position, screen)
    self._timer     = 0
    self._screen    = screen
    self._position  = position
    self._particles = {}
end

function explosion:screen()
    return self._screen
end

function explosion:update(dt)
    self._timer = self._timer + dt
    return self._timer >= explosion._max_time
end

function explosion:active()
    return false
end

return explosion
