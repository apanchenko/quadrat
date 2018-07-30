-------------------------------------------------------------------------------
local Player = {
  Red = true,
  Black = false
}
Player.__index = Player
setmetatable(Player, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
function Player.tostring(color)
  if color then
    return "red"
  end
  return "black"
end

-------------------------------------------------------------------------------
function Player.new(color)
  local self = setmetatable({}, Player)
  self.color = color
  return self
end

-------------------------------------------------------------------------------
function Player:__tostring() 
  return Player.tostring(self.color)
end

return Player