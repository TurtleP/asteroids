local highscores = {}
highscores._data = {
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
  { name = "SSP", score = 42069 },
}

local msgpack = require("libraries.msgpack")

function highscores:enter(previous)
    self._font = love.graphics.newFont("graphics/asteroids-display.otf", 24)

    self._name_column = love.graphics.newTextBatch(self._font, "Name")
    self._name_column_pos = vec2(5, 5)

    self._score_column = love.graphics.newTextBatch(self._font, "Score")
    self._score_column_pos = vec2((VAR("top_screen").x - self._score_column:getWidth()) - 5, 5)

    self._no_data_text = love.graphics.newTextBatch(self._font, "Could not access scores.")
    self._no_data_text_pos = vec2((VAR("top_screen").x - self._no_data_text:getWidth()) * 0.5, (VAR("top_screen").y - self._no_data_text:getHeight()) * 0.5)

    self._current_page   = 1
    self._items_per_page = 6
end

function highscores:exit()
    self._font = nil
end

function highscores:update(dt)
end

function highscores:draw(screen, iod)
    if screen ~= "bottom" then
        love.graphics.draw(self._name_column, self._name_column_pos:unpack())
        love.graphics.draw(self._score_column, self._score_column_pos:unpack())

        if #highscores._data == 0 then
            return love.graphics.draw(self._no_data_text, self._no_data_text_pos:unpack())
        end

        local start_index = (self._current_page - 1) * self._items_per_page + 1
        local end_index   = math.min(start_index + self._items_per_page - 1, #highscores._data)

        for index = start_index, end_index do
            local name, score = highscores._data[index].name, highscores._data[index].score

            local offset = ((index - start_index) + 1) * 32
            love.graphics.print(name, self._font, self._name_column_pos:copy():scalar_add_inplace(0, offset):unpack())

            local score_x = (VAR("top_screen").x - self._font:getWidth(tostring(score))) - 5
            love.graphics.print(score, self._font, score_x, self._score_column_pos.y + offset)
        end

        return
    end
end

function highscores:gamepadpressed(button)
    if button == "dpright" then
        self._current_page = math.min(self._current_page + 1, math.ceil(#highscores._data / self._items_per_page))
    elseif button == "dpleft" then
        self._current_page = math.max(self._current_page - 1, 1)
    end
end

return highscores
