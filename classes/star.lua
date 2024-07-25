local star = class()

function star:new()
    self.r = love.math.random(0.25, 1)
    self.x = love.math.random(self.r * 2, (400 - self.r * 2))
    self.y = love.math.random(self.r * 2, (240 - self.r * 2))
    self.speed = love.math.random(20, 50)
end

function star:update(dt)
    self.y = self.y + self.speed * dt

    if self.y > 240 + self.r * 2 then
        self.y = -self.r * 2
    end
end

function star:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.r)
end

return star
