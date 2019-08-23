local power   = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('mode')
local wrp = require('src.lua-cor.wrp')
local typ = require('src.lua-cor.typ')

local invisible = power:extend('Invisible')

-- can spawn in jade
function invisible:can_spawn()
  return true
end

-- MODULE ---------------------------------------------------------------------
function invisible:wrap()
  wrp.fn(log.info, invisible, 'can_spawn', invisible)
end

--
return invisible