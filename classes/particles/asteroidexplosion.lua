local explosion          = require("classes.particles.explosion")
local asteroidexplosion  = class({ extends = explosion })

asteroidexplosion._speed = 69

function asteroidexplosion:new(position, screen)
    self:super(position, screen)

    local angle, shift = 0, math.pi / 4

    for index = 1, 8 do
        local square =
        {
            position = vec2(position.x, position.y),
            size = vec2(2, 2),

            dx = math.cos(angle) * 10,
            dy = math.sin(angle) * 10,
        }

        angle = angle + shift
        table.insert(self._particles, square)
    end
end

function asteroidexplosion:update(dt)
    for index = 1, #self._particles do
        local particle = self._particles[index]
        particle.position.x = particle.position.x + particle.dx * dt
        particle.position.y = particle.position.y + particle.dy * dt
    end

    return explosion.update(self, dt)
end

function asteroidexplosion:draw()
    love.graphics.setColor(1, 1, 1)

    for _, square in ipairs(self._particles) do
        love.graphics.rectangle("fill", square.position.x, square.position.y, square.size.x, square.size.y)
    end
end

return asteroidexplosion
