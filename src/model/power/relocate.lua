local power = require 'src.model.power.power'
local ass   = require 'src.lua-cor.ass'
local arr = require 'src.lua-cor.arr'
local log = require('src.lua-cor.log').get('model')

local relocate = power:extend('Relocate')

-- can spawn in jade
function relocate:can_spawn()
  return true
end

-- apply power
function relocate:new(piece)
  local space = piece.space
  local from_spot = space:spot(piece.pos)
  -- select all empty spots
  local spots = space:select_spots(function(c) return c.piece == nil end)
  -- choose random target spot
  local to_spot = spots:random()
  -- change piece position
  to_spot:move_piece(from_spot)
end

return relocate