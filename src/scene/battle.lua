local composer      = require 'composer'
local playerid      = require 'src.model.playerid'
local board         = require 'src.view.board'
local player        = require 'src.view.player'
local cfg           = require 'src.cfg'
local lay           = require 'src.core.lay'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'
local wrp           = require 'src.core.wrp'
local env           = require 'src.core.env'
local space         = require 'src.model.space'
local agent         = require 'src.model.agent.package'

-- battle scene
local battle = composer.newScene()

--
function battle.goto_robots()
  env.player_white = agent:get('random'):new(env, playerid.white)
  env.player_black = agent:get('random'):new(env, playerid.black)
  composer.gotoScene('src.scene.battle', cfg.scenes.switching)
  return true
end

--
function battle.goto_solo()
  env.player_white = agent:get('user'):new(env, playerid.white)
  env.player_black = agent:get('random'):new(env, playerid.black)
  composer.gotoScene('src.scene.battle', cfg.scenes.switching)
  return true
end

--
function battle:create(event)
  lay.image(self, cfg.view.battle.bg)

  self.move_pointer = lay.image(self.view, cfg.view.battle.arrow)

  self.players = {}

  local white = playerid.white
  self.players[white] = player(white, "Salvador")
  lay.render(self, self.players[white], cfg.view.player.red)

  local black = playerid.black
  self.players[black] = player(black, "Gala")
  lay.render(self, self.players[black], cfg.view.player.black)

  env.space = space:new(cfg.view.board.cols, cfg.view.board.rows, 1)
  env.space.own_evt:add(self)
  env.battle = self
  env.board = board:new()
  env.space:setup() -- start playing
end

--
function battle:move(pid)
  log:trace('-----------------------------------------------')

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

  log:trace(tostring(self.players[pid]), 'is going to move.', white, black)

  -- move pointer
  transition.moveTo(self.move_pointer, {y=self.players[pid].view.y, time=500})
end

--
function battle:win(message)
  lay.text(self.view, {x=0, vy=50, vw=100, text=message, fontSize=38, align="center"})
end

function battle:show(event) end
function battle:hide(event) end
function battle:destroy(event) end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

-- MODULE-----------------------------------------------------------------------
-- wrap vec functions
function battle.wrap()
  wrp.fn(battle, 'move', {{'playerid'}}, {log = log.info})
end

--
function battle.test()
  print('test battle..')
  ass(true)
end


return battle