local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local wrp       = require 'src.core.wrp'
local obj       = require 'src.core.obj'

local acidic = obj:extend('spot_acidic')

-- constructor
function acidic:new()
  return obj.new(self, {id = self.type})
end

-- spot with acidic cannot receive pieces
function acidic:can_set_piece()
  return false
end

-- spot with acidic cannot receive jades
function acidic:can_set_jade()
  return false
end

-- MODULE ---------------------------------------------------------------------
function acidic:wrap()
end

function acidic.test()
end

return acidic