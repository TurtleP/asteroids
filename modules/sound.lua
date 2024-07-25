local sound = {}

sound.title = love.audio.newSource("audio/title.ogg", "stream")
sound.title:setLooping(true)

sound.theme = love.audio.newSource("audio/bgm.ogg", "stream")
sound.theme:setLooping(true)

sound.fire        = love.audio.newSource("audio/fire.ogg", "static")
sound.thrust      = love.audio.newSource("audio/thrust.ogg", "static")

sound.explosions  =
{
    love.audio.newSource("audio/bangSmall.ogg", "static"),
    love.audio.newSource("audio/bangMedium.ogg", "static"),
    love.audio.newSource("audio/bangLarge.ogg", "static"),
}

sound.skill_issue = love.audio.newSource("audio/skill_issue.ogg", "static")

return sound
