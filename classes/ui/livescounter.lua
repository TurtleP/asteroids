local livescounter = class()

function livescounter:new(ship)
    self._ship = ship
    self._position = vec2(0, 20):scalar_mul(1, 0.75)
end

function livescounter:draw(screen, iod)
    if screen == "bottom" then return end

    for index = 1, self._ship:lives() do
        love.graphics.push()
        love.graphics.setColor(1, 1, 1)

        local left = self._position.x + index * 20

        love.graphics.translate(left - iod * VAR("ui_stereoscopic_depth"), 23)
        love.graphics.scale(0.75, 0.75)

        love.graphics.polygon("line", self._ship._points)

        love.graphics.pop()
    end
end

return livescounter
