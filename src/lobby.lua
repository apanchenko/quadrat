local composer      = require "composer"
local Space         = require 'src.model.Space'
local playerid      = require 'src.model.playerid'
local player        = require 'src.model.players.random'
local Board         = require "src.view.Board"
local Player        = require "src.Player"
local cfg           = require 'src.Config'
local lay           = require 'src.core.lay'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'
local net           = require 'src.net'

-- variables
local lobby = composer.newScene()

-------------------------------------------------------------------------------
function lobby:create(event)
  lay.image(self, cfg.battle.bg)

  local net = net:new()

end

function lobby:on_join_room()
end

function lobby:show(event) end
function lobby:hide(event) end
function lobby:destroy(event) end

lobby:addEventListener("create", lobby)
lobby:addEventListener("show", lobby)
lobby:addEventListener("hide", lobby)
lobby:addEventListener("destroy", lobby)

--
function lobby.test()
  print('test lobby..')
  ass(true)
end

return lobby