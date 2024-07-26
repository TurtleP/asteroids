local highscores = {}
highscores._data = nil

local msgpack = require("libraries.msgpack")

function highscores:_load_data()
    if love.filesystem.exists("save.msgpack") then
        local result = msgpack.unpack(love.filesystem.read("save.msgpack"))
        table.sort(result, function(a, b) return a.score > b.score end)
        return result
    end
    return {}
end

function highscores:_save_data()
    if self._input_user_name then
        love.filesystem.write("save.msgpack", msgpack.pack(highscores._data))
    end
    self._transition = "menu"
end

function highscores:enter(state_machine)
    highscores._data = self:_load_data()

    self._font = love.graphics.newFont("graphics/asteroids-display.otf", 24)

    self._name_column = love.graphics.newTextBatch(self._font, "Name")
    self._name_column_pos = vec2(5, 5)

    self._score_column = love.graphics.newTextBatch(self._font, "Score")
    self._score_column_pos = vec2((VAR("top_screen").x - self._score_column:getWidth()) - 5, 5)

    self._no_data_text = love.graphics.newTextBatch(self._font, "Could not access scores.")
    self._no_data_text_pos = vec2((VAR("top_screen").x - self._no_data_text:getWidth()) * 0.5,
        (VAR("top_screen").y - self._no_data_text:getHeight()) * 0.5)

    self._current_page = 1
    self._items_per_page = 6

    local name = state_machine.prev_state_name
    self._input_user_name = false

    self._transition = nil

    if state_machine:previous_state() and name == "game" then
        self._input_user_name = true
        local score = state_machine:previous_state():score()

        self._input_index = 1
        local create_entry = true

        for index, value in ipairs(highscores._data) do
            if value.score == score then
                self._input_index = index
                highscores._data[index].name = ""
                create_entry = false
                break
            end
        end

        if create_entry then
            table.insert(highscores._data, { name = "", score = score })
        end

        table.sort(highscores._data, function(a, b) return a.score > b.score end)
        love.keyboard.setTextInput(true)

        for index = 10, #highscores._data do
            table.remove(highscores._data, index + 1)
        end
    end
end

function highscores:exit()
    self._font = nil
end

function highscores:textinput(text)
    if not self._input_user_name then return end
    local is_console = functional.contains({ "Cafe", "Horizon" }, love._os)

    if #highscores._data[self._input_index].name < 3 then
        if is_console and not IS_NEST_LOADED then
            highscores._data[self._input_index].name = text:upper()
            self:_save_data()
        else
            highscores._data[self._input_index].name = highscores._data[self._input_index].name .. text:upper()
        end
    end
end

function highscores:update(dt)
    return self._transition
end

function highscores:draw(screen, iod)
    if screen ~= "bottom" then
        love.graphics.draw(self._name_column, self._name_column_pos:unpack())
        love.graphics.draw(self._score_column, self._score_column_pos:unpack())

        if #highscores._data == 0 then
            return love.graphics.draw(self._no_data_text, self._no_data_text_pos:unpack())
        end

        local start_index = (self._current_page - 1) * self._items_per_page + 1
        local end_index = math.min(start_index + self._items_per_page - 1, #highscores._data)

        for index = start_index, end_index do
            local name, score = highscores._data[index].name, highscores._data[index].score

            local offset = ((index - start_index) + 1) * 32
            love.graphics.print(("%d. %s"):format(index, name), self._font,
                self._name_column_pos:copy():scalar_add_inplace(0, offset):unpack())

            local score_x = (VAR("top_screen").x - self._font:getWidth(tostring(score))) - 5
            love.graphics.print(score, self._font, score_x, self._score_column_pos.y + offset)
        end
    end
end

function highscores:gamepadpressed(button)
    if button == "dpright" then
        self._current_page = math.min(self._current_page + 1, math.ceil(#highscores._data / self._items_per_page))
    elseif button == "dpleft" then
        self._current_page = math.max(self._current_page - 1, 1)
    end

    if button == "a" then
        self:_save_data()
    end
end

function highscores:keypressed(key)
    if key == "backspace" then
        if not self._input_user_name then return end
        highscores._data[self._input_index].name = highscores._data[self._input_index].name:sub(1, -2)
    end
end

return highscores
