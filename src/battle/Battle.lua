-- imports
local composer = require "composer"
local Board    = require "src.battle.Board"
local Piece    = require "src.battle.Piece"
local Pos      = require "src.core.Pos"
local Player   = require "src.Player"
local cfg      = require "src.Config"
local lib      = require "src.core.lib"

-- variables
local battle = composer.newScene()

-------------------------------------------------------------------------------
-- battle scene
function battle:create(event)
  -- background
  local back = display.newImageRect(self.view, "src/background.png", display.contentWidth, display.contentHeight)
  back.anchorX = 0
  back.anchorY = 0

  -- move pointer
  self.move_pointer = lib.image(self.view, "src/battle/arrow.png", {vx=4, vy=4, vw=12, ratio=2})

  -- players
  self.players = {}
  self.players[Player.R] = Player(Player.R, "Salvador")
  self.players[Player.B] = Player(Player.B, "Gala")
  lib.render(self.view, self.players[Player.R].group, {vx=18, vy=4})
  lib.render(self.view, self.players[Player.B].group, {vx=18, vy=9})

  -- board
  self.board = Board(cfg.board_size)
  self.board:set_tomove_listener(self)

  self.view:insert(self.board.group)
  print("Create " .. tostring(self.board))

  self.board:position_minimal()
  self.jade_moves = cfg.jade_moves
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
  transition.moveTo(self.move_pointer, {y=self.players[color].group.y, time=500})

  -- drop jades
  self.jade_moves = self.jade_moves - 1
  if self.jade_moves == 0 then
    self.jade_moves = cfg.jade_moves     -- restart jade_moves counter
    self.board:drop_jades(cfg.jade_probability)
  end

end

-------------------------------------------------------------------------------
function battle:_win(message)
  local options = {
    text = message,
    width = display.contentWidth,
    font = native.systemFont,
    fontSize = 38,
    align = "center"
  }
  local text = display.newText(options)
  Pos.center(text)
end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

return battle