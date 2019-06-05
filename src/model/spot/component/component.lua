local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local wrp       = require 'src.lua-cor.wrp'
local obj       = require 'src.lua-cor.obj'

local component = obj:extend('component')

-- MODULE ---------------------------------------------------------------------
function component:wrap()
end

function component:test()
end

return component