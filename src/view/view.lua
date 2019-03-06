local pkg = require 'src.core.pkg'

local view = pkg:new('src.view')

view:load('board', 'stone', 'stoneAbilities')

return view