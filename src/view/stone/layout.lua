local lay = require 'src.lua-cor.lay'
local map = require 'src.lua-cor.map'

local layout = lay.new_layout()

local cell =
{
  x = 0,  y = 0,
  w = 64, h = 64,
  fn = lay.new_image
}
local pimp =
{
  x = 20, y = 20,
  w = 24, h = 24,
  fn = lay.new_image
}

function layout:add_image(name, shape, z, file)
  self.add(name, map.merge(shape,
  {
    z=z, path='src/view/stone/'.. file.. '.png'
  }))
end

layout:add_image('ability_white', cell, 1, 'ability_white')
layout:add_image('ability_black', cell, 1, 'ability_black')
layout:add_image('stone',         cell, 2, 'stone')
layout:add_image('white',         pimp, 3, 'pimp_green')
layout:add_image('black',         pimp, 3, 'pimp_red')
layout:add_image('Jumpproof',     cell, 4, 'jumpproof')
layout:add_image('Movediagonal',  cell, 5, 'movediagonal')
layout:add_image('Parasite',      cell, 6, 'parasite')
layout:add_image('Parasite_host', cell, 7, 'parasite_host')
layout:add_image('Sphere',        cell, 8, 'sphere')

return layout