local menu = {}

local sound = require("modules.sound")

local asteroid = require("classes.entities.asteroid")

menu._title = "Asteroids"
menu._items =
{
    { text = "Play",       transition = "game"       },
    { text = "Highscores", transition = "highscores" }
}

menu._asteroids = {}

function menu:enter(parent)
    self._font = love.graphics.newFont("graphics/asteroids-display.otf", 48)
    self._selection_font = love.graphics.newFont("graphics/asteroids-display.otf", 32)

    self._title_pos = vec2((400 - self._font:getWidth(menu._title)) * 0.5, (240 * 0.25))

    sound.title:play()

    for _ = 1, 10 do
        local screen = love.math.random() > 0.5 and "top" or "bottom"
        local x = screen == "top" and 400 or 320

        local position = vec2(love.math.random(x), love.math.random(240))
        menu._asteroids[#menu._asteroids + 1] = asteroid(position, 3, screen)
    end

    self._transition = nil
    self._selection  = 1
end

function menu:update(dt)
    for _, value in ipairs(menu._asteroids) do
        value:update(dt)
    end

    return self._transition
end

function menu:draw(screen, iod)
    for _, value in ipairs(menu._asteroids) do
        value:draw(screen)
    end

    if screen ~= "bottom" then
        local x, y = self._title_pos:unpack()
        love.graphics.print(menu._title, self._font, x - iod * 4, y)

        for index = 1, #menu._items do
            local color = { 0.5, 0.5, 0.5 }
            if self._selection == index then color = { 1, 1, 1 } end

            local text_y = y + self._font:getHeight() + 32 + (index - 1) * 32
            local text_x = (400 - self._selection_font:getWidth(menu._items[index].text)) * 0.5

            love.graphics.setColor(color)
            love.graphics.print(menu._items[index].text, self._selection_font, text_x, text_y)
        end
    end
end

function menu:gamepadpressed(button)
    if button == "dpdown" then
        self._selection = math.min(self._selection + 1, #menu._items)
    elseif button == "dpup" then
        self._selection = math.max(self._selection - 1, 1)
    end

    if button == "a" then
        self._transition = menu._items[self._selection].transition
    end
end

function menu:exit()
    if self._transition == "game" then
        sound.title:stop()
    end

    self._font = nil
    self._selection_font = nil
end

return menu

