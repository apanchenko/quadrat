local pkg = require 'src.lua-cor.pck'

return pkg
  :new('src.model')
  :packs('agent', 'power', 'spot', 'zones')
  :modules('jade', 'piece', 'playerid', 'space')