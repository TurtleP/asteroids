local intro = {}

function intro:enter()
    self._sound = love.audio.newSource("audio/intro.ogg", "static")
    self._sound:play()

    self._logo = love.graphics.newImage("graphics/logo.png")
    self._logo_opacity = 0

    self._timeout = 1
    self._early_exit = false
end

function intro:exit()
    self._sound:stop()
    self._sound = nil
end

function intro:update(dt)
    if self._early_exit then
        return "menu"
    end

    if not self._sound:isPlaying() then
        self._timeout = self._timeout - dt
        self._logo_opacity = math.max(0, self._logo_opacity - dt)

        if self._timeout <= 0 then
            return "menu"
        end
    else
        self._logo_opacity = math.min(1, self._logo_opacity + dt)
    end
end

function intro:draw(screen, iod)
    if screen == "bottom" then return end

    local width, height = love.graphics.getDimensions()
    local logo_width, logo_height = self._logo:getDimensions()

    love.graphics.setColor(1, 1, 1, self._logo_opacity)
    love.graphics.draw(self._logo, width / 2, height / 2, 0, 1, 1, logo_width / 2, logo_height / 2)
end

function intro:gamepadpressed(button)
    self._early_exit = true
end

return intro
