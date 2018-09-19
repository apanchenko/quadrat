local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local PowerMoveDiagonal = {}
PowerMoveDiagonal.__index = PowerMoveDiagonal

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMoveDiagonal.new(log, view)
  local self = setmetatable({log=log}, PowerMoveDiagonal)
  self.img = lay.image(view, cfg.cell, "src/battle/power_diagonal.png")
  self.log:trace(self, ".new")
  return self
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:__tostring()
  return PowerMoveDiagonal.name()
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal.name()
  return "MoveDiagonal"
end

-------------------------------------------------------------------------------
function PowerMoveDiagonal:increase()
  self.log:trace(self, ":increase diag")
  -- do nothing here
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