local Vec = require 'src.core.Vec'
local lay = require 'src.core.lay'
local ass = require 'src.core.ass'
local cfg = require 'src.Config'

local PowerMoveDiagonal =
{
  typename = "MoveDiagonal",
  is_areal = false
}
PowerMoveDiagonal.__index = PowerMoveDiagonal

-------------------------------------------------------------------------------
function PowerMoveDiagonal.new(Zone)
  assert(Zone == nil)
  local self = setmetatable({}, PowerMoveDiagonal)
  return self
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:apply(piece)
  self.img = lay.image(piece, cfg.cell, "src/battle/powers/move_diagonal.png")
  return self
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:__tostring()
  return PowerMoveDiagonal.typename
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:increase()
  -- do nothing here
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:decrease()
  return self
end

-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMoveDiagonal:can_move(from, to)
  ass.Is(from, Vec)
  ass.Is(to, Vec)

  local diff = from - to
  return (diff.x==1 or diff.x==-1) and (diff.y==1 or diff.y==-1)
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:move_before(cell_from, cell_to)
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:move(vec)
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:move_after(piece, board, cell_from, cell_to)
end


return PowerMoveDiagonal