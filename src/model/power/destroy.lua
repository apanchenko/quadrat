local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local wrp     = require 'src.core.wrp'
local areal   = require 'src.model.power.areal'

local destroy = areal:extend('Destroy')

-- can spawn in jade
function destroy:can_spawn()
  return true
end

-- POWER ----------------------------------------------------------------------
--
function destroy:apply_to_spot(spot)
  if spot.piece and spot.piece.pid ~= self.piece.pid then
    spot.piece:die() -- enemy piece
    spot.piece = nil
    self.piece.space:yell('remove_piece', spot.pos) -- notify
  end
end
--
function destroy:__tostring()
  return self.type.. self.zone.type
end

-- MODULE ---------------------------------------------------------------------
function destroy:wrap()
  wrp.fn(destroy, 'apply_to_spot', {{'spot'}})
end

function destroy.test()
  ass.eq(tostring(destroy), 'Destroy')
end

return destroy