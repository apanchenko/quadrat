local composer = require "composer"
local Board    = require "src.battle.Board"
local Piece    = require "src.battle.Piece"
local vec      = require "src.core.vec"
local Player   = require "src.Player"
local Color    = require 'src.battle.Color'
local cfg      = require 'src.Config'
local lay      = require 'src.core.lay'
local ass      = require 'src.core.ass'
local log      = require 'src.core.log'

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
  self.players[Color.R] = Player(Color.R, "Salvador")
  self.players[Color.B] = Player(Color.B, "Gala")
  lay.render(self, self.players[Color.R], cfg.player.red)
  lay.render(self, self.players[Color.B], cfg.player.black)

  -- board
  self.board = Board.new(self)
  self.board:set_tomove_listener(self)
  self.board:position_minimal()
  log:trace("Create ", self.board, ", w:", self.board.view.width, " sx:", self.board.view.xScale)

  self.jade_moves = cfg.jade.moves
end

-------------------------------------------------------------------------------
function battle:show(event)
end

-------------------------------------------------------------------------------
function battle:hide(event)
end

-------------------------------------------------------------------------------
function battle:destroy(event)
end

-------------------------------------------------------------------------------
function battle:tomove(color)
  local red, bla = self.board:count_pieces()

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

  log:trace(self.players[color].name, " is going to move. Red: ", red, ". Black: ", bla)

  -- move pointer
  transition.moveTo(self.move_pointer, {y=self.players[color].view.y, time=500})

  -- drop jades
  self.jade_moves = self.jade_moves - 1
  if self.jade_moves == 0 then
    self.jade_moves = cfg.jade.moves     -- restart jade_moves counter
    self.board:drop_jades()
  end

end

-------------------------------------------------------------------------------
function battle:win(message)
  lay.text(self.view, {text=message, vw=100, fontSize=38, align="center", vy = 50})
end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

return battle