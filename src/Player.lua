local vec = require 'src.core.vec'
local cfg = require 'src.Config'
local lay = require 'src.core.lay'
local Ass = require 'src.core.Ass'
local Color = require 'src.model.Color'

-------------------------------------------------------------------------------
local Player = {
  typename = "Player"
}
Player.__index = Player
setmetatable(Player, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
-- @param color of the pieces to play
-- @param name
-- @param (optional) display group to render
function Player.new(color, name, view)
  Ass.Is(color, Color)
  Ass.String(name)

  local self = setmetatable({}, Player)

  self.color = color
  self.name = name

  self.view = display.newGroup()

  -- piece image
  lay.image(self, cfg.player, "src/view/stone_"..tostring(self.color)..".png")

  -- player name
  lay.text(self, {text=self.name, vx=8})

  print(tostring(self))
  return self
end

--
function Player:__tostring() 
  return self.name .. ": " .. tostring(self.color)
end

return Player