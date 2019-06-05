local vec = require 'src.lua-cor.vec'
local cfg = require 'src.cfg'
local lay = require 'src.lua-cor.lay'
local ass = require 'src.lua-cor.ass'
local obj = require 'src.lua-cor.obj'
local log = require('src.lua-cor.log').get('view')

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
  lay.new_image(self.view, cfg.view.player)

  -- player name
  lay.new_text(self.view, {text=self.name, font=cfg.font, z=4, vx=8, vy=0})

  log.trace(tostring(self))
  return self
end

--
function player:__tostring() 
  return self.name .. ": " .. tostring(self.pid)
end

return player