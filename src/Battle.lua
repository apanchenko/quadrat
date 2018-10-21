local composer   = require "composer"
local Space      = require 'src.model.Space'
local Color      = require 'src.model.Color'
local VBoard     = require "src.view.Board"
local Stone      = require "src.view.Stone"
local vec        = require "src.core.vec"
local Player     = require "src.Player"
local cfg        = require 'src.Config'
local lay        = require 'src.core.lay'
local ass        = require 'src.core.ass'
local log        = require 'src.core.log'

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

  local color = Color.red(true)
  self.players[color] = Player(color, "Salvador")
  lay.render(self, self.players[color], cfg.player.red)

  color = Color.swap(color)
  self.players[color] = Player(color, "Gala")
  lay.render(self, self.players[color], cfg.player.black)

  self.space = Space.new(cfg.board.cols, cfg.board.rows)
  self.space.on_move:add(self)

  -- board
  self.board = VBoard.new(self, self.space)
  log:trace("Create ", self.board, ", w:", self.board.view.width, " sx:", self.board.view.xScale)

  self.jade_moves = cfg.jade.moves
end

--
function battle:__tostring()
  return 'battle'
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
function battle:on_move()
  local color = self.space:who_move()
  local red, bla = self.space:get_piece_count()
  log:trace(self, ":on_move r ", red, ", b ", bla)

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

  log:trace(tostring(self.players[color]), " is going to move. Red: ", red, ". Black: ", bla)

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