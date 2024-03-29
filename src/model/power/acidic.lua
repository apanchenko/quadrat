local ass         = require 'src.lua-cor.ass'
local log         = require('src.lua-cor.log').get('mode')
local areal       = require 'src.model.power.areal'
local spot_acidic = require 'src.model.spot.component.acidic'

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
  spot.piece:die()
  spot.piece = nil
  self.world.on_remove_piece(spot.pos) -- notify
  -- mark spot as acidic
  spot:add_comp(spot_acidic:new())
end
function acidic:apply_to_enemy_after(spot)
  ass(not spot:can_set_piece())
end

--
function acidic:__tostring()
  return self:get_typename().. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
function acidic:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local spot = require('src.model.spot.spot')

  wrp.fn(log.trace, acidic, 'apply_to_enemy', typ.new_ex(acidic), spot)
end

return acidic