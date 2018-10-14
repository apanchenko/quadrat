local vec   = require "src.core.vec"
local cfg   = require "src.Config"
local lay   = require "src.core.lay"

Cell =
{
  typename = "Cell"
}
Cell.__index = Cell
function Cell:__tostring() return "cell["..tostring(self.pos).."]" end

-------------------------------------------------------------------------------
-- public
Cell.sheet_opt = {width = cfg.cell.w, height = cfg.cell.h, numFrames = 2}
Cell.sheet = graphics.newImageSheet("src/battle/cell_1_s.png", Cell.sheet_opt)

-------------------------------------------------------------------------------
function Cell.new(pos)
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.pos = pos
  self.view = display.newGroup()
  self.img = lay.sheet(self.view, Cell.sheet, frame, cfg.cell)
  return self
end
-- equals
function Cell:equals(cell)
  return cell and self.pos:equals(cell.pos)
end


-------------------------------------------------------------------------------
-- JADE------------------------------------------------------------------------
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

  self:set_jade()
end
-------------------------------------------------------------------------------
function Cell:set_jade()
  assert(self.jade == nil)
  self.jade = lay.image(self.view, cfg.jade)
end
-------------------------------------------------------------------------------
function Cell:remove_jade()
  assert(self.jade)
  self.jade:removeSelf()
  self.jade = nil
end


-------------------------------------------------------------------------------
-- PIECE-----------------------------------------------------------------------
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
    self:remove_jade()
    piece.abilities:add_random()
  end

  self.piece = piece
end


return Cell