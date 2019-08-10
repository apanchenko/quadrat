local pkg = require 'src.lua-cor.pck'

return pkg
  :new('src.model.piece')
  :packs()
  :modules('piece', 'agent')