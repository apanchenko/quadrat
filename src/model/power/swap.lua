local ass       = require 'src.core.ass'
local areal     = require 'src.model.power.areal'

local swap = areal:extend('Swap')

-- implement pure virtual areal:apply_to_spot
-- swap color of all pieces in zone
function swap:apply_to_spot(spot)
  local piece = spot.piece
  if piece then
    piece:set_color(piece.pid.swap())
  end
end

--
ass.wrap(swap, ':apply_to_spot', 'Spot')

return swap