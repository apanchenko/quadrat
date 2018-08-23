local Pos   = require "src.core.Pos"
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
function Cell.new(pos)
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.pos = pos
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

  self.jade = lib.image(self.group, cfg.jade)
end

-------------------------------------------------------------------------------
function Cell:leave()
  assert(self.piece)
  local piece = self.piece;
  self.piece = nil
  return piece
end

-------------------------------------------------------------------------------
function Cell:receive(piece)
  assert(piece)

  -- kill victim
  if self.piece then                      -- peek possible victim at to position
    assert(piece.color ~= self.piece.color) -- cannibalism deprecated
    self.piece:die()
    self.piece = nil
  end

  -- consume jade to get ability
  if self.jade then
    self.jade:removeSelf()
    self.jade = nil
    piece:add_ability()
  end

  self.piece = piece
  piece:move_to(self.pos)                   -- move piece to new position
end


return Cell