local composer      = require "composer"
local Space         = require 'src.model.Space'
local playerid      = require 'src.model.playerid'
local ChangesLog    = require 'src.model.ChangesLog'
local player        = require 'src.model.players.random'
local Board         = require "src.view.Board"
local Stone         = require "src.view.Stone"
local vec           = require "src.core.vec"
local Player        = require "src.Player"
local cfg           = require 'src.Config'
local lay           = require 'src.core.lay'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'

-- variables
local battle = composer.newScene()

-------------------------------------------------------------------------------
-- battle scene
function battle:create(event)
  log:trace("cfg vw:", cfg.vw, ", wh:", cfg.vh)

  -- background
  lay.image(self, cfg.battle.bg)

  -- move pointer
  self.move_pointer = lay.image(self.view, cfg.battle.arrow)

  -- players
  self.players = {}

  local white = playerid.white
  self.players[white] = Player(white, "Salvador")
  lay.render(self, self.players[white], cfg.player.red)

  local black = playerid.black
  self.players[black] = Player(black, "Gala")
  lay.render(self, self.players[black], cfg.player.black)

  self.space = Space:new(cfg.board.cols, cfg.board.rows)
  --self.space.on_change:add(ChangesLog.new())
  self.space.on_change:add(self)

  self.board = Board:new(self, self.space)

  self.bot1 = player:new(self.space, white)
  self.space.on_change:add(self.bot1)
  self.bot2 = player:new(self.space, black)
  self.space.on_change:add(self.bot2)

  self.space:setup() -- start playing
end

--
function battle:move(pid)
  local red, bla = self.space:count_pieces()

  -- check if black wins
  if red == 0 then
    self:win "Black wins!!!"
    return
  end

  -- check if red wins
  if bla == 0 then
    self:win "Red wins!!!"
    return
  end

  log:trace(tostring(self.players[pid]), " is going to move. Red: ", red, ". Black: ", bla)

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

ass.wrap(battle, ':move', 'playerid')

return battle