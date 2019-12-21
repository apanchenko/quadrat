local pkg = require 'src.lua-cor.pack'

return pkg:new('src.model.agent')
          :modules('random', 'user', 'bot')