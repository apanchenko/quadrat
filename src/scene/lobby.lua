local composer      = require 'composer'
local space         = require 'src.model.space.space'
local playerid      = require 'src.model.playerid'
local cfg           = require 'src.scene.cfg'
local lay           = require 'src.lua-cor.lay'
local log           = require('src.lua-cor.log').get('scen')
local wrp           = require('src.lua-cor.wrp')
local typ           = require('src.lua-cor.typ')
local net           = require 'src.model.agent.photon.net'
local agent         = require 'src.model.agent._pack'
local random_player = require('src.model.agent.random')
local user_player   = require('src.model.agent.user')

-- variables
local lobby = composer.newScene()

lobby.options = {effect = 'fade', time = 600}

-------------------------------------------------------------------------------
function lobby:create(event)
  lay.new_image(self, cfg.bg)

  self.net = net:new()

  self.net:find_opponent(
    function(...) self:on_opponent(...) end,
    function(...) self:on_opponent_error(...) end
  )
end

--
function lobby:on_opponent(room_id, createdByMe)
  --local params = { net = self.net }

  local space = space:new(cfg.board.cols, cfg.board.rows, room_id)
  local p1 = random_player:new(space, playerid.select(createdByMe))
  local p2 = user_player:new(space, playerid.select(not createdByMe))

  composer.gotoScene('src.scene.battle', {effect = 'fade', time = 600, params = space})
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
function lobby.goto_lobby()
  composer.gotoScene('src.scene.lobby', {effect = 'fade', time = 600})
  return true
end

-- interface
function lobby:wrap()
  local ex    = typ.new_ex(lobby)
  wrp.fn(log.trace, lobby, 'on_opponent',       ex, typ.num, typ.boo)
  wrp.fn(log.trace, lobby, 'on_opponent_error', ex, typ.str)
end

return lobby