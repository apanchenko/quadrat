local pkg = require 'src.lua-cor.pkg'

return pkg
  :new('src.model')
  :load('agent.package', 'power.package', 'spot.package', 'zones.package', 'jade', 'piece', 'playerid', 'space')