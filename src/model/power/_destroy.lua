local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local areal     = require 'src.model.power.areal'

return function(space, owner, zone)
  local self = areal(space, owner, zone)

  self.apply_to_spot = function(spot)
    if spot.piece and spot.piece.color ~= owner.color then
      spot.piece.die() -- enemy piece
      spot.piece = nil
      space:notify('remove_piece', spot.pos) -- notify
    end
  end

  self.tostring = function()
    return 'Destroy '..tostring(zone)
  end

  return self
end

--[[
local destroy = areal:new()

-- POWER ----------------------------------------------------------------------
--
function destroy:apply_to_spot(spot)
  if spot.piece and spot.piece.color ~= self.owner.color then
    spot.piece.die() -- enemy piece
    spot.piece = nil
    self.space:notify('remove_piece', spot.pos) -- notify
  end
end

--
function destroy:__tostring()
  return tostring(destroy).. ' '.. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(destroy, ':apply_to_spot', 'Spot')
log:wrap(destroy, 'apply_to_spot')

function destroy.test()
  --ass(tostring(Destroy:new()) == 'Destroy Col')
end
--]]