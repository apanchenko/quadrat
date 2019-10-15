local pkg = require 'src.lua-cor.pck'

return pkg
  :new('src.model.space')
  :packs()
  :modules('space', 'Controller', 'board')