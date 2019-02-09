local pkg = require 'src.core.pkg'

local zones = pkg:new('src.model.zones')

zones:load('Row', 'Col', 'Radial')

return zones