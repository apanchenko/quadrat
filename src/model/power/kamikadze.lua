local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local wrp       = require 'src.lua-cor.wrp'
local typ         = require 'src.lua-cor.typ'
local areal     = require 'src.model.power.areal'

local kamikadze = areal:extend('Kamikadze')

-- can spawn in jade
function kamikadze:can_spawn()
  return true
end

-- POWER ----------------------------------------------------------------------
--
function kamikadze:apply_to_spot(spot)
  -- kill any piece
  if spot.piece then
    spot.piece:die()
    spot.piece = nil
    self.piece.space:yell('remove_piece', spot.pos) -- notify
  end
end
--
function kamikadze:__tostring()
  return self:get_typename().. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
function kamikadze:wrap()
  local ex    = {'exkamikadze', typ.new_ex(kamikadze)}
  wrp.wrap_stc(log.trace, kamikadze, 'apply_to_spot', ex, {'spot'})
end

function kamikadze:test()
end

return kamikadze