-- imports
local composer = require("composer")
local Board = require("src.Board")
local Piece = require("src.Piece")
local Pos = require("src.Pos")
local Player = require("src.Player")

-- variables
local battle = composer.newScene()

-------------------------------------------------------------------------------
-- battle scene
function battle:create(event)
  self.board = Board(3, 3, self)
  self.view:insert(self.board.group)
  print("Create " .. tostring(self.board))

  self.board:position_minimal()
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
function battle:onMoved(color)
  local red, bla = self.board:count_pieces()

  print(Player.tostring(color).." moved. Red: "..red..". Black: "..bla)

  if red == 0 then
    self:win "Black wins!!!"
  elseif bla == 0 then
    self:win "Red wins!!!"
  end
end

-------------------------------------------------------------------------------
function battle:win(message)
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