local ass     = require 'src.lua-cor.ass'
local log     = require('src.lua-cor.log').get('mode')
local power   = require 'src.model.power.power'
local wrp     = require('src.lua-cor.wrp')
local typ     = require('src.lua-cor.typ')

local jumpproof = power:extend('Jumpproof')

-- can spawn in jade
function jumpproof:can_spawn()
  return true
end

jumpproof.is_jump_protected = true

-- MODULE ---------------------------------------------------------------------
function jumpproof:wrap()
  local is = {'jumpproof', typ.new_is(jumpproof)}

  wrp.fn(log.info, jumpproof, 'can_spawn', is)
end

--
return jumpproof