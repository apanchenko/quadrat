local power = require 'src.model.power.power'
local ass   = require 'src.core.ass'
local array = require 'src.core.array'

local relocate = power:extend('Relocate')

-- apply power
function relocate:apply()
  local space = self.piece.space
  local from_spot = space:spot(self.piece.pos)
  -- select all empty spots
  local spots = space:select_spots(function(c) return c.piece == nil end)
  -- choose random target spot
  local to_spot = array.random(spots)
  -- change piece position
  to_spot:move_piece(from_spot)
end

return relocate