local pkg = require 'src.core.pkg'

local model = pkg:new('src.model')

model:load('jade', 'piece', 'playerid', 'space')

return model