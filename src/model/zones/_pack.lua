local pkg = require 'src.lua-cor.pack'

local zones = pkg:new('src.model.zones')

zones:modules('row', 'col', 'radial')

return zones