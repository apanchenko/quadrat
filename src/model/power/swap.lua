local ass       = require 'src.lua-cor.ass'
local wrp       = require('src.lua-cor.wrp')
local typ         = require('src.lua-cor.typ')
local areal     = require 'src.model.power.areal'
local log = require('src.lua-cor.log').get('mode')

local swap = areal:extend('Swap')

-- can spawn in jade
function swap:can_spawn()
  return true
end

-- implement pure virtual areal:apply_to_spot
-- swap color of all pieces in zone
function swap:apply_to_spot(spot)
  local piece = spot.piece
  if piece then
    piece:set_color(piece.pid:swap())
  end
end

--
function swap:wrap()
  local spot      = require('src.model.spot.spot')

  local ex    = typ.new_ex(swap)
  wrp.fn(log.info, swap, 'apply_to_spot', ex, spot)
end

return swap