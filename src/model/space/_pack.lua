local pkg = require 'src.lua-cor.pack'

return pkg
  :new('src.model.space')
  :packs()
  :modules('space', 'controller', 'board')