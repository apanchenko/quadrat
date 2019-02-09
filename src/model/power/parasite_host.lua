local ass       = require 'src.core.ass'
local wrp       = require 'src.core.wrp'
local power     = require 'src.model.power.power'

-- @see parasite
local parasite_host = power:extend('parasite_host')

--
function areal:apply_to_self()
end

--
function parasite_host:apply_to_enemy(piece)
end

--
function parasite_host.wrap()
  wrp.fn(parasite_host, 'apply_to_self', {})
  wrp.fn(parasite_host, 'apply_to_enemy', {{'Piece'}})
end

return parasite_host