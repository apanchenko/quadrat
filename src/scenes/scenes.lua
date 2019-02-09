local pkg = require 'src.core.pkg'

local scenes = pkg:new('src.scenes')

scenes:load('menu', 'solo', 'lobby', 'battle', 'exit')

return scenes