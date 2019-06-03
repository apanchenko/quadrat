local ass     = require 'src.lua-cor.ass'
local log     = require('src.lua-cor.log').get('model')
local power   = require 'src.model.power.power'

local jumpproof = power:extend('Jumpproof')

-- can spawn in jade
function jumpproof:can_spawn()
  return true
end

jumpproof.is_jump_protected = true


--
return jumpproof