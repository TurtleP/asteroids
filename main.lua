math.tau = math.pi * 2

require("libraries.batteries"):export()
require("util")

states = require("states")

function love.load()
    love.audio.setVolume(VAR("volume"))
end

function love.update(dt)
    states:update(dt)
end

function love.draw(screen, iod)
    states:_call("draw", screen, iod)
end

function love.textinput(text)
    states:_call("textinput", text)
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

function love.keypressed(key)
    states:_call("keypressed", key)
end

IS_NEST_LOADED = require("libraries.nest").init({ emulate_joystick = false })
