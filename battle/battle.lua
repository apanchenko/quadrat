-- imports
local composer = require("composer")
local Board = require("battle.board")

-- variables
local battle = composer.newScene()
local cell_w = display.contentWidth / 8
local cell_h = cell_w -- make cells square
local cell_sheet_opt = {width = 64, height = 64, numFrames = 2}
local cell_sheet = graphics.newImageSheet("battle/cell_1_s.png", cell_sheet_opt)

-- functions
local function create_cell(group, i, j)
  local frame = math.random(1, cell_sheet_opt.numFrames);
  local cell = display.newImageRect(group, cell_sheet, frame, cell_w, cell_h)
  cell.x = i * cell_w - cell_w / 2
  cell.y = j * cell_h
  return cell
end

-- battle scene
function battle:create(event)
  local battle_group = self.view
  local board = Board(8, 8)
  battle_group:insert(board.display_group)
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