math.tau = math.pi * 2

require("libraries.batteries"):export()
require("util")

states = require("states")

function love.load()
end

function love.update(dt)
    states:update(dt)
end

function love.draw(screen, iod)
    states:_call("draw", screen, iod)
end

function love.gamepadpressed(_, button)
    states:_call("gamepadpressed", button)

    if button == "start" then
        love.event.quit()
    end
end

function love.gamepadaxis(_, axis, value)
    states:_call("gamepadaxis", axis, value)
end

require("libraries.nest").init()
