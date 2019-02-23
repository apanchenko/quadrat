local vec = require 'src.core.vec'
local cfg = require 'src.model.cfg'
local lay = require 'src.core.lay'
local ass = require 'src.core.ass'
local obj = require 'src.core.obj'

-------------------------------------------------------------------------------
local Player = obj:extend('Player')

-------------------------------------------------------------------------------
-- @param color of the pieces to play
-- @param name
-- @param (optional) display group to render
function Player:new(pid, name)
  ass.str(name)

  self = obj.new(self,
  {
    pid = pid,
    name = name,
    view = display.newGroup()
  })

  -- piece image
  cfg.player.path = "src/view/stone_"..tostring(self.pid)..".png"
  lay.image(self, cfg.player)

  -- player name
  lay.text(self, {text=self.name, vx=8, vy=0})

  print(tostring(self))
  return self
end

--
function Player:__tostring() 
  return self.name .. ": " .. tostring(self.pid)
end

return Player