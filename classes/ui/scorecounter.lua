local score = class()

local font = love.graphics.newFont("graphics/asteroids-display.otf", 24)

function score:new()
    self._score = 0
end

function score:draw(screen, iod)
    if screen == "bottom" then return end

    local x = (VAR("top_screen").x - font:getWidth(tostring(self._score))) - 5

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self._score, font, x - iod * VAR("ui_stereoscopic_depth"), 10)
end

function score:increment(value)
    self._score = math.max(self._score + value, 0)
end

function score:score()
    return self._score
end


return score
