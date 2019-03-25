local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local power   = require 'src.model.power.power'

local jumpproof = power:extend('Jumpproof')

-- can spawn in jade
function jumpproof:can_spawn()
  return true
end

jumpproof.is_jump_protected = true


--
return jumpproof