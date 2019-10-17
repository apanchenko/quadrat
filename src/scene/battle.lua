local composer      = require 'composer'
local playerid      = require 'src.model.playerid'
local board         = require 'src.view.board'
local player        = require 'src.view.player'
local cfg           = require 'src.scene.cfg'
local lay           = require 'src.lua-cor.lay'
local log           = require('src.lua-cor.log').get('scen')
local wrp           = require('src.lua-cor.wrp')
local space         = require 'src.model.space.space'
local Controller    = require 'src.model.space.controller'
local space_board   = require 'src.model.space.board'
local agent         = require 'src.model.agent._pack'
local com     = require 'src.lua-cor.com'

-- battle scene
local battle = composer.newScene()

-- private
local _model = {}

--
function battle.goto_robots()
  cfg.switching.params = {white = 'bot', black = 'random'}
  composer.gotoScene('src.scene.battle', cfg.switching)
  return true
end

--
function battle.goto_bot()
  cfg.switching.params = {white = 'bot', black = 'user'}
  composer.gotoScene('src.scene.battle', cfg.switching)
  return true
end

--
function battle.goto_solo()
  cfg.switching.params = {white = 'random', black = 'user'}
  composer.gotoScene('src.scene.battle', cfg.switching)
  return true
end

--
function battle:create(event)
  com(self) -- turn self into component

  lay.new_image(self.view, cfg.bg)

  self[_model] = space:new(cfg.board.cols, cfg.board.rows, 1)

  self.move_pointer = lay.new_image(self.view, cfg.arrow)

  self.players = {}

  local white = playerid.white
  self.players[white] = player(white, "Salvador")
  lay.insert(self.view, self.players[white].view, cfg.player.red)

  local black = playerid.black
  self.players[black] = player(black, "Gala")
  lay.insert(self.view, self.players[black].view, cfg.player.black)

  local controller_white = Controller:new(self[_model], playerid.white)
  local controller_black = Controller:new(self[_model], playerid.black)

  self.board = board(space_board(self[_model]), self.view, controller_white, controller_black)
  lay.insert(self.view, self.board.view, cfg.board.view)

  self.player_white = agent:get(event.params.white):new(controller_white)
  self.player_black = agent:get(event.params.black):new(controller_black)

  if event.params.black == 'user' then
    self.board:listen_spawn_stone(self.player_black, true)
    self.board:listen_stone_color_changed(self.player_black, true)
  end
  self.board:get_space():listen_set_move(self, true) -- todo unlisten

  self[_model]:setup() -- start playing
end

--
function battle:set_move(pid)
  log.trace('-----------------------------------------------')

  local counts = self[_model]:count_pieces()
  local white = counts[tostring(playerid.white)]
  local black = counts[tostring(playerid.black)]

  -- check if black wins
  if white == 0 then
    self:win "Black wins!!!"
    return
  end

  -- check if red wins
  if black == 0 then
    self:win "White wins!!!"
    return
  end

  log.trace(tostring(self.players[pid]), 'is going to move.', white, black)

  -- move pointer
  transition.moveTo(self.move_pointer, {y=self.players[pid].view.y, time=500})
end

--
function battle:win(message)
  lay.new_text(self.view, {x=0, vy=50, vw=100, z=4, text=message, fontSize=38, font=cfg.font, align="center"})
end

--
function battle:resize(event)
  --log.trace('Event '..event.name)
  log.trace('display.content         '..display.contentWidth..'*'..display.contentHeight)
  log.trace('display.actualContent   '..display.actualContentWidth..'*'..display.actualContentHeight)
  log.trace('display.viewableContent '..display.viewableContentWidth..'*'..display.viewableContentHeight)
  log.trace('display.screenOrigin    '..display.screenOriginX..'*'..display.screenOriginY)
end

function battle:show(event) end
function battle:hide(event) end
function battle:destroy(event) end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

-- Add the "resize" event listener
Runtime:addEventListener('resize', function(event) battle.resize(event) end)


-- MODULE-----------------------------------------------------------------------
-- wrap vec functions
function battle:wrap()
  wrp.fn(log.info, battle, 'set_move', battle, playerid)
end

return battle