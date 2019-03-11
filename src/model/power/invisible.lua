local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local power   = require 'src.model.power.power'

local invisible = power:extend('invisible')

-- can spawn in jade
function invisible:can_spawn()
  return true
end


--
return invisible