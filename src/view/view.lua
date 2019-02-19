local pkg = require 'src.core.pkg'

local view = pkg:new('src.view')

view:load('board', 'cell', 'stone', 'stoneAbilities')

return view