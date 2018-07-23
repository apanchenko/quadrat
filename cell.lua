local Pos = require("Pos")

Cell = {}
Cell.__index = Cell
setmetatable(Cell, {__call = function(cls, ...) return cls.new(...) end})
function Cell:__tostring() return "cell" end

-------------------------------------------------------------------------------
-- public
Cell.size = Pos(64, 64)
Cell.sheet_opt = {width = Cell.size.x, height = Cell.size.y, numFrames = 2}
Cell.sheet = graphics.newImageSheet("cell_1_s.png", Cell.sheet_opt)

function Cell.new()
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.group = display.newGroup()
  self.img = display.newImageRect(self.group, Cell.sheet, frame, Cell.size.x, Cell.size.y)
  self.img.anchorX = 0
  self.img.anchorY = 0
  return self
end

function Cell:insert_into(board, i, j)
  self.group.x = i * Cell.size.x
  self.group.y = j * Cell.size.y
  board.group:insert(self.group)
end

return Cell