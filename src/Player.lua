local Pos = require "src.core.Pos"
local cfg = require "src.Config"
local lib = require "src.core.lib"

-------------------------------------------------------------------------------
local Player = {
  R = true,
  B = false
}
Player.__index = Player
setmetatable(Player, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
-- @param color of the pieces to play
-- @param name
-- @param (optional) display group to render
function Player.new(color, name, group)
  assert(color == Player.R or color == Player.B)
  assert(type(name) == "string")

  local self = setmetatable({}, Player)

  self.color = color
  self.name = name

  self.group = display.newGroup()

  -- piece image
  lib.image(self.group, "src/battle/piece_"..Player.tostring(self.color)..".png", {vw=6, ratio=1})

  -- player name
  lib.text(self.group, {text=self.name, vx=8})

  print(tostring(self))
  return self
end

-------------------------------------------------------------------------------
function Player.tostring(color)
  if color == Player.R then
    return "red"
  end
  return "black"
end

-------------------------------------------------------------------------------
function Player:__tostring() 
  return self.name .. ": " .. Player.tostring(self.color)
end

return Player