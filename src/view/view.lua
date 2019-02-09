local pkg = require 'src.core.pkg'

local view = pkg:new('src.view')

view:load('Board', 'Cell', 'Stone', 'StoneAbilities')

return view