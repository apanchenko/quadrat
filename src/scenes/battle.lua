local composer      = require 'composer'
local playerid      = require 'src.model.playerid'
local board         = require 'src.view.board'
local player        = require 'src.view.player'
local cfg           = require 'src.model.cfg'
local lay           = require 'src.core.lay'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'
local wrp           = require 'src.core.wrp'

-- battle scene
local battle = composer.newScene()

-------------------------------------------------------------------------------
function battle:create(event)
  log:trace("cfg vw:", cfg.vw, ", wh:", cfg.vh)

  -- background
  lay.image(self, cfg.battle.bg)

  -- move pointer
  self.move_pointer = lay.image(self.view, cfg.battle.arrow)

  -- players
  self.players = {}

  local white = playerid.white
  self.players[white] = player(white, "Salvador")
  lay.render(self, self.players[white], cfg.player.red)

  local black = playerid.black
  self.players[black] = player(black, "Gala")
  lay.render(self, self.players[black], cfg.player.black)

  self.env = event.params
  self.env.battle = self
  
  self.space = self.env.space
  self.space.on_change:add(self)

  self.env.board = board:new(self, self.space)
  self.board = self.env.board

  self.space:setup() -- start playing
end

--
function battle:move(pid)
  log:trace('-----------------------------------------------')

  local counts = self.space:count_pieces()
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
  lay.text(self.view, {text=message, vw=100, fontSize=38, align="center", vy = 50})
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