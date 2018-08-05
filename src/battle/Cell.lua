local Pos   = require "src.core.Pos"
local Jade  = require "src.battle.Jade"
local cfg   = require "src.Config"

Cell = {}
Cell.__index = Cell
setmetatable(Cell, {__call = function(cls, ...) return cls.new(...) end})
function Cell:__tostring() return "cell" end

-------------------------------------------------------------------------------
-- public
Cell.sheet_opt = {width = cfg.cell_size.x, height = cfg.cell_size.y, numFrames = 2}
Cell.sheet = graphics.newImageSheet("src/battle/cell_1_s.png", Cell.sheet_opt)

-------------------------------------------------------------------------------
function Cell.new()
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.group = display.newGroup()
  self.img = display.newImageRect(self.group, Cell.sheet, frame, cfg.cell_size.x, cfg.cell_size.y)
  self.img.anchorX = 0
  self.img.anchorY = 0
  return self
end

-------------------------------------------------------------------------------
function Cell:insert_into(board, i, j)
  self.group.x = i * cfg.cell_size.x
  self.group.y = j * cfg.cell_size.y
  board.group:insert(self.group)
end

-------------------------------------------------------------------------------
-- may spawn jade
function Cell:drop_jade(jade_probability)
  assert(type(jade_probability) == "number")
  assert(jade_probability >= 0)
  assert(jade_probability <= 1)

  if self.piece or self.jade then
    return
  end

  if math.random() > jade_probability then
    return
  end

  self.jade = Jade(self.group)
end


return Cell