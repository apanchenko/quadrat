local vec   = require "src.core.Vec"
local cfg   = require "src.Config"
local lay   = require "src.core.lay"
local ass   = require "src.core.ass"

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


-------------------------------------------------------------------------------
-- JADE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Cell:set_jade()
  ass.nul(self.jade, 'jade')
  ass.nul(self.piece, 'piece')
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
--
function Cell:leave()
  ass(self.piece)
  local piece = self.piece;
  self.piece = nil
  return piece
end
-------------------------------------------------------------------------------
function Cell:receive(piece)
  ass(piece)

  -- kill victim
  if self.piece then                      -- peek possible victim at to position
    ass(piece.color ~= self.piece.color) -- cannibalism deprecated
    self.piece:putoff()
  end

  -- consume jade to get ability
  if self.jade then
    self:remove_jade()
    piece.abilities:add_random()
  end

  self.piece = piece
end


return Cell