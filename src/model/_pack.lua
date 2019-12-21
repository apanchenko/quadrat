local pkg = require 'src.lua-cor.pack'

return pkg
  :new('src.model')
  :packs('agent', 'piece', 'power', 'spot', 'space', 'zones')
  :modules('jade', 'playerid')