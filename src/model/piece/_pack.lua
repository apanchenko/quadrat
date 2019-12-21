local pkg = require 'src.lua-cor.pack'

return pkg
  :new('src.model.piece')
  :packs()
  :modules('piece', 'asset')