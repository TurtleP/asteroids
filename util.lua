local VARIABLES = require "variables"

function VAR(name, default)
    return VARIABLES[name] == nil and default or VARIABLES[name]
end

function FONT(size)
    return love.graphics.newFont("graphics/asteroids-display.otf", size)
end

---Lerps between two colors
---@param a number
---@param b number
---@param time number
function lerpColor(a, b, time)
    local first  = { color.unpack_rgb(a) }
    local second = { color.unpack_rgb(b) }

    local r      = first[1] + (second[1] - first[1]) * time
    local g      = first[2] + (second[2] - first[2]) * time
    local b      = first[3] + (second[3] - first[3]) * time

    return color.pack_rgb(r, g, b)
end

function isOnScreen(screen, object)
    local obj_screen = object:screen()
    return (screen == "left" or screen == "right") and obj_screen == "top" or
        (screen == "bottom" and obj_screen == "bottom")
end


