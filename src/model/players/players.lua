local pkg = require 'src.core.pkg'

local players = pkg:new('src.model.players')

players:load('random', 'remote', 'user')

return players