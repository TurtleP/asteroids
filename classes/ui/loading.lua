local loading = class()

loading._rect_size = 4

local glyphs =
{
    {
        { 1, 1, 1 },
        { 1, 1, 0 },
        { 1, 0, 0 }
    },
    {
        { 1, 1, 1 },
        { 1, 1, 1 },
        { 0, 0, 0 }
    },
    {
        { 1, 1, 1 },
        { 0, 1, 1 },
        { 0, 0, 1 }
    },
    {
        { 0, 1, 1 },
        { 0, 1, 1 },
        { 0, 1, 1 }
    },
    {
        { 0, 0, 1 },
        { 0, 1, 1 },
        { 1, 1, 1 }
    },
    {
        { 0, 0, 0 },
        { 1, 1, 1 },
        { 1, 1, 1 }
    },
    {
        { 1, 0, 0 },
        { 1, 1, 0 },
        { 1, 1, 1 }

    },
    {
        { 1, 1, 0 },
        { 1, 1, 0 },
        { 1, 1, 0 }
    }
}

function loading:new(screen)
    self._size = 9 * self._rect_size

    self._x = 400 - self._size - 4
    self._y = 240 - self._size - 4

    self._screen = screen
    self._index = 1
    self._timer = 0

    self._should_draw = false
    self._life_timer = timer(3, nil, function()
        self._should_draw = false
    end
end

function loading:activate()
    self._should_draw = true
end

function loading:update(dt)
    if not self._should_draw then return end

    self._timer = self._timer + 16 * dt
    self._index = math.floor(self._timer % #glyphs) + 1
end

function loading:draw(screen)
    if not self._should_draw then return end

    for y = 1, 3 do
        for x = 1, 3 do
            local current = glyphs[self._index][y][x]
            if current == 1 then
                local rect_x = self._x + (x - 1) * (self._rect_size + 1)
                local rect_y = self._y + (y - 1) * (self._rect_size + 1)

                love.graphics.rectangle("fill", rect_x, rect_y, self._rect_size, self._rect_size)
            end
        end
    end
end

return loading
