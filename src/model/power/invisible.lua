local power   = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('model')

local invisible = power:extend('Invisible')

-- can spawn in jade
function invisible:can_spawn()
  return true
end


--
return invisible