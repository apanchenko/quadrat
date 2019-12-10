local power = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('mode')

local relocate = power:extend('Relocate')

-- can spawn in jade
function relocate:can_spawn()
  return true
end

-- apply power
function relocate:new(piece, world)
  local from_spot = world:spot(piece.pos)
  -- select all empty spots
  local spots = world:select_spots(function(c) return c.piece == nil end)
  -- choose random target spot
  local to_spot = spots:random()
  -- change piece position
  to_spot:move_piece(from_spot)
end

-- MODULE ---------------------------------------------------------------------
function relocate:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local Piece = require('src.model.piece.piece')
  local World = require('src.model.space.space')

  wrp.fn(log.trace, relocate, 'new', relocate, typ.ext(Piece), typ.ext(World), typ.tab)
  wrp.fn(log.info, relocate, 'can_spawn', relocate)
end

return relocate