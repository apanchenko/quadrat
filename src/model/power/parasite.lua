local ass       = require 'src.lua-cor.ass'
local wrp       = require 'src.lua-cor.wrp'
local areal     = require 'src.model.power.areal'
local host      = require 'src.model.power.parasite_host'
local log = require('src.lua-cor.log').get('mode')

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
function parasite:wrap()
  wrp.wrap_sub(log.trace, parasite, 'apply_to_self')
  wrp.wrap_sub(log.trace, parasite, 'apply_to_enemy', {'spot'})
end

return parasite