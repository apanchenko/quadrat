local power   = require 'src.model.power.power'

local invisible = power:extend('Invisible')

-- can spawn in jade
function invisible:can_spawn()
  return true
end


--
return invisible