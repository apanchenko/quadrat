local Pos   = require "src.core.Pos"
local Jade  = require "src.battle.Jade"
local cfg   = require "src.Config"
local lib   = require "src.core.lib"

Cell = {}
Cell.__index = Cell
setmetatable(Cell, {__call = function(cls, ...) return cls.new(...) end})
function Cell:__tostring() return "cell" end

-------------------------------------------------------------------------------
-- public
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 2}
Cell.sheet = graphics.newImageSheet("src/battle/cell_1_s.png", Cell.sheet_opt)

-------------------------------------------------------------------------------
function Cell.new()
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.group = display.newGroup()
  self.img = lib.sheet(self.group, Cell.sheet, frame, cfg.cell)
  return self
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