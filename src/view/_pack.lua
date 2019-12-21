local pkg = require 'src.lua-cor.pack'

return pkg:new('src.view')
  :packs('power', 'stone', 'spot')
  :modules('board')