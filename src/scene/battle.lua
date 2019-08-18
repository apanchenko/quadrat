local composer      = require 'composer'
local playerid      = require 'src.model.playerid'
local board         = require 'src.view.board'
local player        = require 'src.view.player'
local cfg           = require 'src.scene.cfg'
local lay           = require 'src.lua-cor.lay'
local log           = require('src.lua-cor.log').get('scen')
local wrp           = require 'src.lua-cor.wrp'
local env           = require 'src.lua-cor.env'
local space         = require 'src.model.space.space'
local space_agent   = require 'src.model.space.agent'
local space_board   = require 'src.model.space.board'
local agent         = require 'src.model.agent._pack'
local typ     = require 'src.lua-cor.typ'
local com     = require 'src.lua-cor.com'

-- battle scene
local battle = composer.newScene()

--
function battle.goto_robots()
  cfg.switching.params = {white = 'random', black = 'random'}
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

  env.space = space:new(cfg.board.cols, cfg.board.rows, 1)

  self.move_pointer = lay.new_image(self.view, cfg.arrow)

  self.players = {}

  local white = playerid.white
  self.players[white] = player(white, "Salvador")
  lay.insert(self.view, self.players[white].view, cfg.player.red)

  local black = playerid.black
  self.players[black] = player(black, "Gala")
  lay.insert(self.view, self.players[black].view, cfg.player.black)

  env.space.own_evt.add(self)
  env.battle = self

  self.space_board = space_board:new(env.space)
  self.board = board:new(self.space_board)

  local space_white = space_agent:new(env.space, playerid.white)
  local space_black = space_agent:new(env.space, playerid.black)

  self.player_white = agent:get(event.params.white):new(space_white)
  self.player_black = agent:get(event.params.black):new(space_black)

  if event.params.black == 'user' then
    self.board.on_change:listen(self.player_black)
  end

  env.space:setup() -- start playing



  --env.board.view.walk_tree()
end

--
function battle:move(pid)
  log.trace('-----------------------------------------------')

  local counts = env.space:count_pieces()
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
  local is   = {'battle', typ.new_is(battle)}
  wrp.fn(log.info, battle, 'move', is, {'playerid'})
end

return battle