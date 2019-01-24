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
local wrp           = require 'src.core.wrp'
local typ           = require 'src.core.typ'
local net           = require 'src.net'
local players       = require 'src.model.players.players'

-- variables
local lobby = composer.newScene()

-------------------------------------------------------------------------------
function lobby:create(event)
  lay.image(self, cfg.battle.bg)

  self.net = net:new()

  self.net:find_opponent(
    function(...) self:on_opponent(...) end,
    function(...) self:on_opponent_error(...) end
  )
end

--
function lobby:on_opponent(room_id, createdByMe)
  --local params = { net = self.net }

  local space = Space:new(cfg.board.cols, cfg.board.rows, room_id)
  local p1 = players.random:new(space, playerid.select(createdByMe))
  local p2 = players.user:new(space, playerid.select(not createdByMe))

  space.on_change:add(p1)
  space.on_change:add(p2)

  composer.gotoScene('src.scenes.battle', {effect = 'fade', time = 600, params = space})
end

--
function lobby:on_opponent_error(msg)
end

--
function lobby:show(event) end
function lobby:hide(event) end
function lobby:destroy(event) end

lobby:addEventListener("create", lobby)
lobby:addEventListener("show", lobby)
lobby:addEventListener("hide", lobby)
lobby:addEventListener("destroy", lobby)

--
wrp.fn(lobby, 'on_opponent', {{'room_id', typ.num}, {'createdByMe', typ.boo}}, 'lobby')
wrp.fn(lobby, 'on_opponent_error', {{'msg', typ.str}}, 'lobby')

function lobby.test()
  print('test lobby..')
  ass(true)
end

return function()
  composer.gotoScene('src.lobby', {effect = 'fade', time = 600})
end