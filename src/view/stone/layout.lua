local lay = require 'src.lua-cor.lay'

local layout = lay.new_layout()

layout.add('ability_white',
{
  z = 1,
  x = 0,
  y = 0,
  w = 64,
  h = 64,
  path = 'src/view/ability_white.png',
  fn = lay.new_image
})

layout.add('ability_black',
{
  z = 1,
  x = 0,
  y = 0,
  w = 64,
  h = 64,
  path = 'src/view/ability_black.png',
  fn = lay.new_image
})

layout.add('stone',
{
  z = 2,
  x = 0,
  y = 0,
  w = 64,
  h = 64,
  path = 'src/view/stone/stone.png',
  fn = lay.new_image
})

layout.add('white',
{
  z = 3,
  x = 20,
  y = 20,
  w = 24,
  h = 24,
  path = 'src/view/stone/pimp_green.png',
  fn = lay.new_image
})

layout.add('black',
{
  z = 3,
  x = 20,
  y = 20,
  w = 24,
  h = 24,
  path = 'src/view/stone/pimp_red.png',
  fn = lay.new_image
})

return layout