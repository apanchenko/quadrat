local vec = require 'src.core.Vec'
local lay = require 'src.core.lay'
local Ass = require 'src.core.Ass'
local cfg = require 'src.Config'
local log = require 'src.core.log'

local Sphere =
{
  typename = "Sphere",
  is_areal = false
}
Sphere.__index = Sphere

-------------------------------------------------------------------------------
function Sphere.new(Zone)
  Ass.Nil(Zone)

  local self = setmetatable({}, Sphere)
  return self
end
-------------------------------------------------------------------------------
function Sphere:apply(piece)
  self.piece = piece
  self.img = lay.image(piece, cfg.cell, "src/view/powers/sphere.png")
  return self
end
-------------------------------------------------------------------------------
function Sphere:__tostring()
  return Sphere.typename
end
-------------------------------------------------------------------------------
function Sphere:increase()
  -- do nothing here
end
-------------------------------------------------------------------------------
function Sphere:decrease()
  return self
end

-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Sphere:can_move(from, to)
  --log:trace(self, ":can_move from ", from, " to ", to)
  local cols = self.piece.board.model:cols()
  local rows = self.piece.board.model:rows()
  local vec = (from - to):abs()
  return (vec.x==0 and vec.y==cols-1) or (vec.x==rows-1 and vec.y==0)
end
-------------------------------------------------------------------------------
function Sphere:move_before(cell_from, cell_to) end
function Sphere:move(vec) end
function Sphere:move_after(piece, board, cell_from, cell_to) end


return Sphere