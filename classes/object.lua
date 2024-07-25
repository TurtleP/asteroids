local object = class()

---Create a new object
---@param position Batteries.Vec2 position
---@param points   table {x, y, ...}
function object:new(position, points)
    self._position = position

    self._velocity = vec2(0)

    self._delete = false
    self._points = points or {}

    self._screen = "top"
    self._active = true
end

---Calculates the AABB size of the object
function object:calculateSize()
    local width, height = -math.huge, -math.huge

    for i = 1, #self._points, 2 do
        width  = math.max(width, self._points[i])
        height = math.max(height, self._points[i + 1])
    end

    self._size = vec2(width, height) * 2
end

---Draws the bounds of the object
function object:drawBounds()
    love.graphics.setColor(1, 0, 0)

    local x, y = self._position:unpack()
    love.graphics.rectangle("line", x - (self._size.x / 2), y - (self._size.y / 2), self._size.x, self._size.y)
end

---Converts the points to a table of vectors
---@return table
function object:points()
    local result = {}

    for i = 1, #self._points, 2 do
        table.insert(result, vec2(self._position.x + self._points[i], self._position.y + self._points[i + 1]))
    end

    return result
end

---Changes the screen of the object
---@param screen string
---@param y number
function object:__changeScreen(screen, y)
    local add = screen == "top" and 40 or -40

    self._position:scalar_add_inplace(add, 0)
    self._position:scalar_set(self._position.x, y)
    self._screen = screen
end

function object:__checkScreen()
    if self._screen ~= "bottom" then
        if self._position.y > 240 then
            self:__changeScreen("bottom", 0)
        elseif self._position.y + self._size.y < 0 then
            self:__changeScreen("bottom", 240)
        end
    else
        if self._position.y + self._size.y < 0 then
            self:__changeScreen("top", 240)
        elseif self._position.y > 240 then
            self:__changeScreen("top", 0)
        end
    end

    local width = self._screen == "top" and 400 or 320
    self._position.x = self._position.x % width
end

---Returns if the object is active
---@return boolean
function object:active()
    return self._active
end

---Returns the position of the object
---@return number x, number y
function object:position()
    return self._position:unpack()
end

---Returns the size of the object
---@return unknown
function object:size()
    return self._size:unpack()
end

---Returns the velocity of the object
---@return number x, number y
function object:velocity()
    return self._velocity:unpack()
end

---Returns if the object should be deleted
---@return boolean
function object:delete()
    return self._delete
end

---Returns the screen the object is on
---@return string
function object:screen()
    return self._screen
end

return object
