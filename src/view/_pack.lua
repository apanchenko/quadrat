local pkg = require 'src.lua-cor.pck'

return pkg:new('src.view')
  :packs('stone')
  :load('board', 'spot.cell')