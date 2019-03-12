local pkg = require 'src.core.pkg'

local agent = pkg:new('src.model.agent')

agent:load('random', 'remote', 'user')

return agent