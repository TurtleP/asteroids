local object = require("classes.object")
local asteroid = class({ name = "asteroid", extends = object })

local explosion = require("classes.particles.asteroidexplosion")

local sound = require("modules.sound")

asteroid._sizes = { 15, 25, 40 }

local function generatePoints(radius, sides)
    local points = {}

    for i = 1, sides do
        local angle = (i / sides) * math.pi * 2
        local distance = radius * (0.5 + love.math.random())

        local x = distance * math.cos(angle)
        local y = distance * math.sin(angle)

        table.insert(points, x)
        table.insert(points, y)
    end

    return points
end

function asteroid:new(position, generation, screen)
    local sides = love.math.random(5, 12)
    local points = generatePoints(asteroid._sizes[generation or 3], sides)

    self:super(position, points)

    self:calculateSize()
    self._generation = generation or 3

    self._screen = screen or "top"

    local target_x = screen == "top" and love.math.random(400) or love.math.random(320)
    local target_y = love.math.random(240)

    local angle = math.atan2(target_y - self._position.y, target_x - self._position.x)
    local v = love.math.random(0, 50)
    self._velocity:scalar_set(math.cos(angle) * v, math.sin(angle) * v)
end

function asteroid:update(dt)
    object.__checkScreen(self)

    self._position = self._position + self._velocity * dt
end

function asteroid:draw(screen)
    if screen and not isOnScreen(screen, self) then return end
    if not self._active then return end

    love.graphics.push()
    love.graphics.translate(self:position())

    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", self._points)

    love.graphics.pop()
end

function asteroid:collide(name, v)
    if name ~= "bullet" and name ~= "ship" then return end
    if not self._active or self._delete then return end

    if name == "ship" then
        if not v:alive() or v:invincible() then
            return
        end
    end

    self._active = false
    self._delete = true

    states:_call("addObject", explosion(self._position, self._screen))
    sound.explosions[self._generation]:play()

    if self._generation == 1 then
        return
    end

    for _ = 1, 2 do
        states:_call("addObject", asteroid(self._position, self._generation - 1, self._screen))
    end
end

return asteroid
