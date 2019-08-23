local pkg = require 'src.lua-cor.pck'

return pkg:new('src.view')
  :packs('power', 'stone', 'spot')
  :modules('board')