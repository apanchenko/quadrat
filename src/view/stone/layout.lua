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
local active =
{
  x = 1, y = 1,
  w = 64, h = 64,
  fn = lay.new_image
}

function layout:add_image(id, shape, z, file)
  self.add(id, map.merge(shape,
  {
    z=z, path='src/view/stone/'.. file.. '.png'
  }))
end

layout:add_image('aura_white',    cell,   1, 'aura_white')
layout:add_image('aura_black',    cell,   1, 'aura_black')
layout:add_image('stone',         cell,   2, 'stone')
layout:add_image('white',         pimp,   3, 'pimp_green')
layout:add_image('black',         pimp,   3, 'pimp_red')
layout:add_image('active_white',  active, 4, 'active_green')
layout:add_image('active_black',  active, 4, 'active_red')
layout:add_image('Jumpproof',     cell,   5, 'jumpproof')
layout:add_image('Movediagonal',  cell,   6, 'movediagonal')
layout:add_image('Parasite',      cell,   7, 'parasite')
layout:add_image('Parasite_host', cell,   8, 'parasite_host')
layout:add_image('Sphere',        cell,   9, 'sphere')
layout:add_image('Scavenger',     cell,   10, 'scavenger')

return layout