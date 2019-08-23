local ass     = require 'src.lua-cor.ass'
local log     = require('src.lua-cor.log').get('mode')
local wrp     = require 'src.lua-cor.wrp'
local typ         = require 'src.lua-cor.typ'
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
  local spot = require('src.model.spot.spot')
  local ex   = typ.new_ex(destroy)

  wrp.fn(log.trace, destroy, 'apply_to_spot', ex, spot)
end

return destroy