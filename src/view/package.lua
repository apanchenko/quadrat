local pkg = require 'src.lua-cor.pkg'

return pkg:new('src.view')
  :load('stone.package', 'board', 'stoneAbilities', 'spot.cell')