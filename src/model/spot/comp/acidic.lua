local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local wrp       = require 'src.core.wrp'
local obj       = require 'src.core.obj'

local acidic = obj:extend('spot_acidic')

-- constructor
function acidic:new()
  return obj.new(self, {id = self.type})
end

-- MODULE ---------------------------------------------------------------------
function acidic.wrap()
end

function acidic.test()
end

return acidic