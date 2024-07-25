local object = require("classes.object")
local bullet = class({ name = "bullet", extends = object })

bullet._speed = 300

function bullet:new(owner, position, angle, screen)
    self:super(position:vector_sub_inplace(vec2(2, 0)), { 0, 0, 4, 0, 4, 4, 0, 4 })
    self:calculateSize()

    self._screen = screen
    self._velocity:scalar_set(math.cos(angle) * bullet._speed, math.sin(angle) * bullet._speed)
    self._owner = owner
end

function bullet:update(dt)
    if not self._active then return end

    object.__checkScreen(self)

    self._position = self._position + self._velocity * dt
end

function bullet:draw()
    if not self._active then return end

    love.graphics.push()
    love.graphics.translate(self:position())

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, 4, 4)

    love.graphics.pop()
end

function bullet:collide(name, v)
    self._delete = true
    self._active = false

    if name == "asteroid" then
        states:_call("addScore", 20)
    elseif name == "ship" then
        states:_call("addScore", -50)
    end
end

function bullet:owner()
    return self._owner
end

return bullet
