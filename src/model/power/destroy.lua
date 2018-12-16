local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local areal     = require 'src.model.power.areal'

local destroy = areal:extend('Destroy')

-- POWER ----------------------------------------------------------------------
--
function destroy:apply_to_spot(spot)
  if spot.piece and spot.piece.pid ~= self.piece.pid then
    spot.piece.die() -- enemy piece
    spot.piece = nil
    self.piece.space:notify('remove_piece', spot.pos) -- notify
  end
end
--
function destroy:__tostring()
  return 'Destroy '.. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(destroy, ':apply_to_spot', 'Spot')
log:wrap(destroy, 'apply_to_spot')

function destroy.test()
  ass.eq(tostring(destroy), 'Destroy')
end

return destroy