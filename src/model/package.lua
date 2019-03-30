local pkg = require 'src.core.pkg'

return pkg
  :new('src.model')
  :load('agent.package', 'power.package', 'spot.package', 'zones.package', 'jade', 'piece', 'playerid', 'space')