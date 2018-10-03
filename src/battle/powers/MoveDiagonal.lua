local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

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
function PowerMoveDiagonal:can_move(vec)
  --print("PowerMoveDiagonal:can_move vec "..tostring(vec))
  return (vec.x==1 or vec.x==-1) and (vec.y==1 or vec.y==-1)
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