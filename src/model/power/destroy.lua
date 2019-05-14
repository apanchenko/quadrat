local ass     = require 'src.lua-cor.ass'
local log     = require 'src.lua-cor.log'
local wrp     = require 'src.lua-cor.wrp'
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
  return self:get_typename().. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
function destroy:wrap()
  wrp.wrap_sub_trc(destroy, 'apply_to_spot', {'spot'})
end

function destroy:test()
  ass.eq(tostring(destroy), 'Destroy')
end

return destroy