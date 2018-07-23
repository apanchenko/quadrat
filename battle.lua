-- imports
local composer = require("composer")
local Board = require("board")
local Piece = require("piece")
local Pos = require("Pos")

-- variables
local battle = composer.newScene()

-- battle scene
function battle:create(event)
  local board = Board(8, 8)
  self.view:insert(board.group)
  print("Create " .. tostring(board))

  --board:put(Piece(Piece.RED), Pos(2, 3))
  board:position_default()
end

function battle:show(event)
end

function battle:hide(event)
end

function battle:destroy(event)
end

battle:addEventListener("create", battle)
battle:addEventListener("show", battle)
battle:addEventListener("hide", battle)
battle:addEventListener("destroy", battle)

return battle