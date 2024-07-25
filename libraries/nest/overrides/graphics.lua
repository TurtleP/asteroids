local current_screen = nil
local has_stereoscopic_depth = true
local stereoscopic_depth = 0.0
love.graphics.setActiveScreen = function(screen)
  current_screen = screen
end
love.graphics.getWidth = function()
  return current_screen:getWidth()
end
love.graphics.getHeight = function()
  return current_screen:getHeight()
end
love.graphics.getDimensions = function()
  return current_screen:getWidth(), current_screen:getHeight()
end
love.graphics.getPixelWidth = function()
  return love.graphics.getWidth()
end
love.graphics.getPixelHeight = function()
  return love.graphics.getHeight()
end
love.graphics.getPixelDimensions = function()
  return love.graphics.getDimensions()
end
love.graphics.get3D = function()
  return has_stereoscopic_depth
end
love.graphics.set3D = function(enable)
  has_stereoscopic_depth = enable
end
love.graphics.getDepth = function()
  return stereoscopic_depth
end
love.graphics.setDepth = function(value)
  stereoscopic_depth = math.max(0, math.min(stereoscopic_depth + value, 1))
end
