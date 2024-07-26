local object = require("classes.object")
local ship = class({ name = "ship", extends = object })

local bullet = require("classes.entities.bullet")

local sound = require("modules.sound")
local explosion = require("classes.particles.shipexplosion")

ship._rotate_speed = 4
ship._speed = 100
ship._drag = 0.75
ship._max_speed = ship._speed
ship._max_flashes = 12
ship._start_position = vec2((400 - 20) / 2, (240 - 20) / 2)
ship._shoot_delay = 0.5

ship._player_colors =
{
    0xFFFFFF,
    0xF44336,
    0x4CAF50,
    0x2196F3
}

ship._thrust_colors =
{
    0xFF5722,
    0xFF3D00
}

function ship:new(index)
    self:super(ship._start_position, { -10, 10, 0, 2, 10, 10, 0, -20 })
    self.thrust = { -3, 7, 0, 2, 3, 7, 0, 11 }

    self:calculateSize()
    self._thrust_timer = timer(0.03, nil, function()
        self._draw_thrust = not self._draw_thrust
    end, true)

    self._lives = 3
    self._index = index

    self:respawn()

    self._can_shoot = true
    self._shoot_timer = timer(ship._shoot_delay, nil, function()
        self._can_shoot = true
        self._shoot_timer:reset()
    end)
end

function ship:respawn()
    self._velocity = vec2(0)

    self._alive = true
    self._rotation = 0
    self._rotation_speed = 0

    self._thrust = false
    self._thrust_color = nil
    self._thrust_lerp_time = 0
    self._draw_thrust = false

    self._revive_timer = nil

    self._spawn_flashes = 0
    self._drawable = true

    self._spawn_timer = timer(0.05, nil, function()
        self._spawn_flashes = math.min(self._spawn_flashes + 1, ship._max_flashes)

        if self._spawn_flashes == ship._max_flashes then
            self._spawn_timer = nil
            self._drawable = true
            return
        end

        self._drawable = not self._drawable
    end, true)
end

function ship:update(dt)
    object.__checkScreen(self)

    if self._spawn_timer then
        self._spawn_timer:update(dt)
    end

    if self._revive_timer then
        self._revive_timer:update(dt)
    end

    if not self._alive then
        return self._lives == 0
    end

    if self._thrust_timer then
        self._thrust_timer:update(dt)
    end

    if not self._can_shoot then
        self._shoot_timer:update(dt)
    end

    self._rotation = self._rotation + self._rotation_speed * dt

    if self._thrust then
        local x, y = math.cos(self._rotation - math.pi / 2), math.sin(self._rotation - math.pi / 2)
        self._velocity:scalar_add_inplace(x * ship._max_speed * dt, y * ship._max_speed * dt)
    else
        self._velocity:scalar_mul_inplace(1 - ship._drag * dt)
    end

    self._position:vector_add_inplace(self._velocity * dt)
end

function ship:draw()
    if not self._drawable then return end
    if not self._alive then return end

    love.graphics.push()
    love.graphics.translate(self:position())
    love.graphics.rotate(self._rotation)

    love.graphics.setColor(color.unpack_rgb(ship._player_colors[self._index]))
    love.graphics.polygon("line", self._points)

    if self._draw_thrust and self._thrust then
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("line", self.thrust)
    end

    love.graphics.pop()
end

function ship:collide(name, v)
    if not self._alive then return end
    if self._spawn_timer then return end

    self._alive = false
    self._lives = self._lives - 1

    if self._lives > 0 then
        sound.explosions[2]:play()
        self._revive_timer = timer(3, nil, function()
            self:respawn()
        end)
    end

    states:_call("addObject", explosion(self._position, self._screen))

    if name == "bullet" and v:owner() == self then
        sound.skill_issue:play()
    end
end

function ship:gamepadaxis(axis, value)
    if not self._alive then return end

    if axis == "leftx" then
        if value ~= 0 and math.abs(value) > 0.5 then
            self._rotation_speed = value * ship._rotate_speed
        else
            self._rotation_speed = 0
        end
    elseif axis == "lefty" then
        self._thrust = value < -0.5

        if self._thrust and not sound.thrust:isPlaying() then
            sound.thrust:play()
        end
    end
end

function ship:calculateBulletPosition()
    local offset = vec2(math.cos(self._rotation - math.pi / 2) * 20, math.sin(self._rotation - math.pi / 2) * 20)
    sound.fire:play()
    return self._position:copy():vector_add_inplace(offset)
end

function ship:shoot()
    if not self._can_shoot or not self._alive then return end

    local position = self:calculateBulletPosition()
    local angle = self:angle() - math.pi / 2
    states:_call("addObject", bullet(self, position, angle, self:screen()))

    self._can_shoot = false
end

function ship:dead()
    return (not self:alive() and self:lives() == 0)
end

function ship:invincible()
    return self._spawn_timer ~= nil
end

function ship:alive()
    return self._alive
end

function ship:angle()
    return self._rotation
end

function ship:lives()
    return self._lives
end

return ship
