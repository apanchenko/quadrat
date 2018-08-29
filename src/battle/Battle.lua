-- imports
local composer = require "composer"
local Board    = require "src.battle.Board"
local Piece    = require "src.battle.Piece"
local vec      = require "src.core.vec"
local Player   = require "src.Player"
local cfg      = require "src.Config"
local lay      = require "src.core.lay"

-- variables
local battle = composer.newScene()

-------------------------------------------------------------------------------
-- battle scene
function battle:create(event)
  print("cfg vw:"..cfg.vw..", wh:"..cfg.vh)

  -- background
  lay.image(self.view, cfg.battle.bg)

  -- move pointer
  self.move_pointer = lay.image(self.view, cfg.battle.arrow)

  -- players
  self.players = {}
  self.players[Player.R] = Player(Player.R, "Salvador")
  self.players[Player.B] = Player(Player.B, "Gala")
  lay.render(self.view, self.players[Player.R].view, cfg.player.red)
  lay.render(self.view, self.players[Player.B].view, cfg.player.black)

  -- board
  self.board = Board()
  self.board:set_tomove_listener(self)
  lay.render(self.view, self.board.view, cfg.board)


  print("Create " .. tostring(self.board)..", w:"..self.board.view.width.." sx:"..self.board.view.xScale)

  self.board:position_minimal()
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
    self:_win "Black wins!!!"
    return
  end

  -- check if red wins
  if bla == 0 then
    self:_win "Red wins!!!"
    return
  end

  print(self.players[color].name.." is going to move. Red: "..red..". Black: "..bla)

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
function battle:_win(message)
  lay.text(self.view, {text=message, vw=100, fontSize=38, align="center", vy = 50})
end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

return battle