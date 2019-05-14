local pkg = require 'src.lua-cor.pkg'

local zones = pkg:new('src.model.zones')

zones:load('row', 'col', 'radial')

return zones