local vec = require 'src.luacor.vec'
local cfg = require 'src.cfg'
local lay = require 'src.luacor.lay'
local ass = require 'src.luacor.ass'
local obj = require 'src.luacor.obj'

-------------------------------------------------------------------------------
local player = obj:extend('player')

-------------------------------------------------------------------------------
-- @param color of the pieces to play
-- @param name
-- @param (optional) display group to render
function player:new(pid, name)
  ass.str(name)

  self = obj.new(self,
  {
    pid = pid,
    name = name,
    view = display.newGroup()
  })

  -- piece image
  cfg.view.player.path = "src/view/stone_"..tostring(self.pid)..".png"
  lay.image(self, cfg.view.player)

  -- player name
  lay.text(self, {text=self.name, vx=8, vy=0})

  print(tostring(self))
  return self
end

--
function player:__tostring() 
  return self.name .. ": " .. tostring(self.pid)
end

return player