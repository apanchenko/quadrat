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
function layout:add_power(id, shape, z, file)
  self.add(id, map.merge(shape,
  {
    z=z, path='images/power/'.. file.. '.png'
  }))
end
function layout:add_piece(id, shape, z, file)
  self.add(id, map.merge(shape,
  {
    z=z, path='images/piece/'.. file.. '.png'
  }))
end

layout:add_piece('aura_white',    cell,   1, 'ability_white')
layout:add_piece('aura_black',    cell,   1, 'ability_black')
layout:add_piece('stone',         cell,   2, 'body')
layout:add_piece('white',         cell,   3, 'pimp_white')
layout:add_piece('black',         cell,   3, 'pimp_black')
layout:add_piece('active_white',  active, 4, 'active_white')
layout:add_piece('active_black',  active, 4, 'active_black')
layout:add_power('Jumpproof',     cell,   5, 'jumpproof')
layout:add_power('Movediagonal',  cell,   6, 'movediagonal')
layout:add_power('Parasite',      cell,   7, 'parasite')
layout:add_power('Parasite_host', cell,   8, 'parasite_host')
layout:add_power('Sphere',        cell,   9, 'sphere')
layout:add_power('Scavenger',     cell,   10, 'scavenger')

return layout