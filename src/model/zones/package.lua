local pkg = require 'src.luacor.pkg'

local zones = pkg:new('src.model.zones')

zones:load('row', 'col', 'radial')

return zones