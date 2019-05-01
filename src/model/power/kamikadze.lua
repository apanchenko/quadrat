local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local wrp       = require 'src.core.wrp'
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
  return self.type.. self.zone.type
end

-- MODULE ---------------------------------------------------------------------
function kamikadze:wrap()
  wrp.fn(kamikadze, 'apply_to_spot', {{'spot'}})
end

function kamikadze.test()
end

return kamikadze