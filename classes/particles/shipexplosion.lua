local explosion = require("classes.particles.explosion")
local shipexplosion = class({extends = explosion})

function shipexplosion:new(position, screen)
    self:super(position, screen)

    for _ = 1, 4 do
        local angle = love.math.random() * math.tau
        local end_x, end_y = position.x + math.cos(angle) * 10, position.y + math.sin(angle) * 10

        local line =
        {
            starts = vec2(position.x, position.y),
            ends   = vec2(end_x, end_y),

            dx = love.math.random(-30, 30),
            dy = love.math.random(-30, 30),

            center = vec2((position.x + end_x) / 2, (position.y + end_y) / 2),
            offset = vec2(0),
            rotation = 0
        }

        table.insert(self._particles, line)
    end
end

function shipexplosion:update(dt)
    for index = 1, #self._particles do
        local particle = self._particles[index]
        particle.rotation = particle.rotation + 0.5 * dt

        particle.offset.x = particle.offset.x + particle.dx * dt
        particle.offset.y = particle.offset.y + particle.dy * dt
    end

    return explosion.update(self, dt)
end

function shipexplosion:draw()
    love.graphics.setColor(1, 1, 1)

    for _, line in ipairs(self._particles) do
        love.graphics.push()
        love.graphics.translate(line.offset.x, line.offset.y)

        local l_start = line.starts:copy()
        local l_ends  = line.ends:copy()

        l_start:rotate_around_inplace(line.rotation, line.center)
        l_ends:rotate_around_inplace(line.rotation, line.center)

        love.graphics.line(l_start.x, l_start.y, l_ends.x, l_ends.y)
        love.graphics.pop()
    end
end

return shipexplosion
