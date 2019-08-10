local pkg = require 'src.lua-cor.pck'

return pkg
  :new('src.model')
  :packs('agent', 'piece', 'power', 'spot', 'space', 'zones')
  :modules('jade', 'playerid')