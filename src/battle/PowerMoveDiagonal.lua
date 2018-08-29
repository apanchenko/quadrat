local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

PowerMoveDiagonal = {}
PowerMoveDiagonal.__index = PowerMoveDiagonal
setmetatable(PowerMoveDiagonal, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
function PowerMoveDiagonal.new(view)
  local self = setmetatable({}, PowerMoveDiagonal)
  self.img = lay.image(view, cfg.cell, "src/battle/power_diagonal.png")
  return self
end

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMoveDiagonal:__tostring() return PowerMoveDiagonal.name() end
function PowerMoveDiagonal.typename() return "PowerMoveDiagonal" end
function PowerMoveDiagonal.name() return "MoveDiagonal" end

-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMoveDiagonal:can_move(vec)
  --print("PowerMoveDiagonal:can_move vec "..tostring(vec))
  return (vec.x==1 or vec.x==-1) and (vec.y==1 or vec.y==-1)
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:move(vec)
end
-------------------------------------------------------------------------------
function PowerMoveDiagonal:move_after(piece, board, cell_from, cell_to)
end


return PowerMoveDiagonal