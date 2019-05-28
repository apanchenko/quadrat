local lay = require 'src.lua-cor.lay'

local layout = lay.new_layout()

layout.add('stone',
{
  z = 1,
  x = 0,
  y = 0,
  w = 64,
  h = 64,
  path = 'src/view/stone/stone.png',
  fn = lay.img
})

layout.add('white',
{
  z = 2,
  x = 20,
  y = 20,
  w = 24,
  h = 24,
  path = 'src/view/stone/pimp_green.png',
  fn = lay.img
})

layout.add('black',
{
  z = 2,
  x = 20,
  y = 20,
  w = 24,
  h = 24,
  path = 'src/view/stone/pimp_red.png',
  fn = lay.img
})

return layout