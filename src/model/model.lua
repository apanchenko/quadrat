local pkg = require 'src.core.pkg'

local model = pkg:new('src.model')

model:load('jade', 'Piece', 'playerid', 'Space', 'Spot')

return model