local ass       = require 'src.core.ass'
local counted   = require 'src.model.power.counted'

local multiply = counted:extend('multiply')

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function multiply:move_after(from, to)
  local piece = self.piece
  from:spawn_piece(piece.color)
  piece:decrease_power(tostring(self)) -- decrease
end

--
ass.wrap(multiply, ':move_after', 'Spot', 'Spot')

return multiply