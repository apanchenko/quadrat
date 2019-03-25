local ass       = require 'src.core.ass'
local wrp       = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'
local host      = require 'src.model.power.parasite_host'

-- Leeches onto any surrounding enemy pieces. Any new powers they acquire your piece will also acquire.
local parasite = areal:extend('Parasite')

-- can spawn in jade
function parasite:can_spawn()
  return true
end

--
function parasite:apply_to_self()
  self.piece:add_power(self)
end

--
function parasite:apply_to_enemy(spot)
  spot.piece:add_power(host:new(spot.piece, {}))
end

--
function parasite.wrap()
  wrp.fn(parasite, 'apply_to_self', {})
  wrp.fn(parasite, 'apply_to_enemy', {{'spot'}})
end

return parasite