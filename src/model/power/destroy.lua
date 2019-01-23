local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local wrp     = require 'src.core.wrp'
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
function destroy.wrap()
  wrp.fn(destroy, 'apply_to_spot', {{'Spot'}})
end

function destroy.test()
  ass.eq(tostring(destroy), 'Destroy')
end

return destroy