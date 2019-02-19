local pkg = require 'src.core.pkg'

local zones = pkg:new('src.model.zones')

zones:load('row', 'col', 'radial')

return zones