local ass       = require 'src.lua-cor.ass'
local wrp     = require 'src.lua-cor.wrp'
local areal     = require 'src.model.power.areal'
local log = require('src.lua-cor.log').get('mode')

local recruit = areal:extend('Recruit')

-- can spawn in jade
function recruit:can_spawn()
  return true
end

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function recruit:apply_to_spot(spot)
  local mypid = self.piece.pid
  local piece = spot.piece
  if piece and piece.pid ~= mypid then
    piece:set_color(mypid)
  end
end

--
function recruit:wrap()
  wrp.wrap_sub(log.trace, recruit, 'apply_to_spot', {'spot'})
end

return recruit