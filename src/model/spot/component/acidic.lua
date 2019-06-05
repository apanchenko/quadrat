local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local wrp       = require 'src.lua-cor.wrp'
local obj       = require 'src.lua-cor.obj'
local component = require 'src.model.spot.component.component'

local acidic = component:extend('spot_acidic')

-- constructor
function acidic:new()
  return obj.new(self, {id = self:get_typename()})
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

function acidic:test()
end

return acidic