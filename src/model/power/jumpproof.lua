local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local power   = require 'src.model.power.power'

local jumpproof = power:extend('jumpproof')

jumpproof.is_jump_protected = true

--
return jumpproof