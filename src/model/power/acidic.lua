local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local wrp         = require 'src.core.wrp'
local areal       = require 'src.model.power.areal'
local spot_acidic = require 'src.model.spot.comp.acidic'

local acidic = areal:extend('Acidic')

-- can spawn in jade
function acidic:can_spawn()
  return true
end

-- POWER ----------------------------------------------------------------------
function acidic:apply_to_enemy_before(spot)
  ass.nul(spot.jade)
end
function acidic:apply_to_enemy(spot)
  -- kill enemy piece
  spot.piece.die()
  spot.piece = nil
  self.piece.space:yell('remove_piece', spot.pos) -- notify
  -- mark spot as acidic
  spot:add_comp(spot_acidic())
end
function acidic:apply_to_enemy_after(spot)
  ass(not spot:can_set_piece())
end

--
function acidic:__tostring()
  return self.type.. self.zone.type
end

-- MODULE ---------------------------------------------------------------------
function acidic.wrap()
  wrp.fn(acidic, 'apply_to_enemy', {{'spot'}})
end

function acidic.test()
end

return acidic