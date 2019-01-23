local ass     = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local counted = require 'src.model.power.counted'

local multiply = counted:extend('multiply')

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function multiply:move_after(from, to)
  local piece = self.piece
  from:spawn_piece(piece.pid)
  piece:decrease_power(tostring(self)) -- decrease
end

--
function multiply.wrap()
  wrp.fn(multiply, 'move_after', {{'Spot'}})
end

return multiply