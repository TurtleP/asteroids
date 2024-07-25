local game = {}

local STAR_LAYERS_COUNT = 3
local STARS_PER_LAYER_COUNT = 50
local STAR_LAYERS = {}

local star = require("classes.star")

local function generateStarLayers()
    for i = 1, STAR_LAYERS_COUNT do
        local layer = { stars = {} }
        for j = 1, STARS_PER_LAYER_COUNT do
            table.insert(layer.stars, star())
        end
        table.insert(STAR_LAYERS, layer)
    end
end

ship               = require("classes.entities.ship")
asteroid           = require("classes.entities.asteroid")
bullet             = require("classes.entities.bullet")

local livescounter = require("classes.ui.livescounter")
local scorecounter = require("classes.ui.scorecounter")

local world        = require("modules.world")
local sound        = require("modules.sound")

local function spawnAroundArea(pos)
    local screen = love.math.random() > 0.5 and "top" or "bottom"
    local position = vec2(love.math.random(400), screen == "top" and 0 or 240)
    local center = position:copy():scalar_div_inplace(2)

    if pos then center = pos end

    while position:distance(center) < 100 do
        position = vec2(love.math.random(400), screen == "top" and 0 or 240)
    end

    return position, screen
end

function game:enter()
    generateStarLayers()
    world.init(self)

    self.players = {}
    for index = 1, VAR("players") do
        local player = ship(index)
        world.addObject(self, player)
        table.insert(self.players, player)
    end

    sound.theme:play()

    for _ = 1, 5 do
        local position, screen = spawnAroundArea()
        world.addObject(self, asteroid(position, 3, screen))
    end

    self._lives_counter = livescounter(self.players[1])
    self._score_counter = scorecounter()

    self._asteroid_timer = timer(5, nil, function()
        local count = world.countObjects(self, "asteroid")
        if count >= 10 then return end
        spawnAroundArea()
    end, true)
end

function game:update(dt)
    for _, layer in ipairs(STAR_LAYERS) do
        for _, v in ipairs(layer.stars) do
            v:update(dt)
        end
    end

    self._asteroid_timer:update(dt)
    world.update(self, dt)
end

function game:draw(screen, iod)
    for _, layer in ipairs(STAR_LAYERS) do
        for _, v in ipairs(layer.stars) do
            v:draw()
        end
    end

    world.draw(self, screen)
    self._lives_counter:draw(screen, iod)
    self._score_counter:draw(screen, iod)
end

function game:gamepadpressed(button)
    if button == "a" then
        self.players[1]:shoot()
    end
end

function game:gamepadaxis(axis, value)
    self.players[1]:gamepadaxis(axis, value)
end

function game:addObject(object)
    world.addObject(self, object)
end

function game:addScore(score)
    self._score_counter:increment(score)
end

function game:score()
    return self._score_counter:score()
end

return game
