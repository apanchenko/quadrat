local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

PowerMultiply = {}
PowerMultiply.__index = PowerMoveDiagonal
setmetatable(PowerMultiply, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
function PowerMultiply.new(view)
  local self = setmetatable({}, PowerMoveDiagonal)
  self.img = lay.image(view, cfg.cell, "src/battle/power_diagonal.png")
  return self
end


-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMultiply:__tostring() return PowerMultiply.name() end
function PowerMultiply.typename() return "PowerMultiply" end
function PowerMultiply.name() return "Multiply" end



-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMultiply:can_move(vec)
  return false
end
-------------------------------------------------------------------------------
function PowerMultiply:move(vec)
end
-------------------------------------------------------------------------------
function PowerMultiply:move_after(piece, board, cell_from, cell_to)
  board.put(piece.color, cell_from.pos.x, cell_from.pos.y)
end

return PowerMultiply