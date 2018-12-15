local ass       = require 'src.core.ass'
local areal     = require 'src.model.power.areal'

local recruit = areal:extend('Recruit')

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function recruit:apply_to_spot(spot)
  local my_color = self.piece.color
  local piece = spot.piece
  if piece and piece.color ~= my_color then
    piece:set_color(my_color)
  end
end

--
ass.wrap(recruit, ':apply_to_spot', 'Spot')

return recruit