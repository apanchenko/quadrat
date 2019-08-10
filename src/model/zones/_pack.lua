local pkg = require 'src.lua-cor.pck'

local zones = pkg:new('src.model.zones')

zones:modules('row', 'col', 'radial')

return zones