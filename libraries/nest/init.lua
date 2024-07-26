local path = (...):gsub('%.init$', '')
local nest = {
    _VERSION = "0.5.0",
    _DESCRIPTION = "LÖVE Potion Compatabiility Layer library",
    _LICENSE = [[      MIT LICENSE
      Copyright (c) TurtleP
      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:
      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],
    URL = "https://github.com/lovebrew/nest",
    _LOVE_VERSION = "12.0",
    init = function(user_config)
        return false
    end
}
-- check if homebrew is being ran, if this is copied
-- we don't want to run this, that would be bad™
if love._console then
    return nest
end
if not love.isVersionCompatible(nest._LOVE_VERSION) then
    error("This library is only compatible with LÖVE " .. tostring(nest._LOVE_VERSION) .. "!")
end
local CTR = require(path .. ".classes.consoles.ctr")
local HAC = require(path .. ".classes.consoles.hac")
local CAFE = require(path .. ".classes.consoles.cafe")
local Joystick = require(path .. ".classes.joystick")
local joystick = nil
local hook = require(path .. ".libraries.hook")
local config = require(path .. ".config")
local _anon_func_0 = function(user_config)
    if user_config ~= nil then
        return user_config
    else
        return {}
    end
end
local _anon_func_1 = function(nest)
    local _exp_0 = nest._CONFIG.scale
    if _exp_0 ~= nil then
        return _exp_0
    else
        return 1
    end
end
local _anon_func_2 = function(options)
    if options ~= nil then
        return options
    else
        return {}
    end
end
nest.init = function(user_config)
    nest._CONFIG = config.update(_anon_func_0(user_config))
    require(path .. ".overrides.graphics")
    require(path .. ".overrides.system")
    require(path .. ".overrides.constants")
    local console, options
    do
        local _exp_0 = nest._CONFIG.console
        if "ctr" == _exp_0 then
            console, options = CTR, nil
        elseif "hac" == _exp_0 then
            console, options = HAC, nil
        elseif "cafe" == _exp_0 then
            console, options = CAFE, {
                nest._CONFIG.mode
            }
        else
            console, options = error("Invalid console " .. tostring(nest._CONFIG.console))
        end
    end
    local simulation = console(_anon_func_1(nest), unpack(_anon_func_2(options)))
    xpcall(function()
        local chunk
        chunk = function(x)
            return require(path .. ".runner")(x)
        end
        love.run = chunk(simulation)
    end, function(e)
        return print(e)
    end)
    if nest._CONFIG.emulate_joystick then
        joystick = Joystick()
        hook.add("keypressed", {
            function(key)
                return joystick:keypressed(key)
            end
        })
        hook.add("keyreleased", {
            function(key)
                return joystick:keyreleased(key)
            end
        })
        -- hook.add("update", {
        --   function(dt)
        --     return joystick:update()
        --   end
        -- })
    end
    hook.add("keypressed", {
        function(key)
            return simulation:input(key)
        end
    })
    hook.add("mousepressed", {
        function(x, y)
            return simulation:mousepressed(x, y)
        end
    })
    hook.add("mousereleased", {
        function(x, y)
            return simulation:mousereleased(x, y)
        end
    })
    hook.add("mousemoved", {
        function(x, y, dx, dy)
            return simulation:mousemoved(x, y, dx, dy)
        end
    })
    hook.add("wheelmoved", {
        function(x, y)
            if y > 0 then
                return love.graphics.setDepth(0.1)
            else
                return love.graphics.setDepth(-0.1)
            end
        end
    })
    return true
end
return nest
