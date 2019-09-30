local lay = require 'src.lua-cor.lay'
local map = require 'src.lua-cor.map'

local layout = lay.new_layout()

local cell =
{
  x = 0,  y = 0,
  w = 64, h = 64,
  fn = lay.new_image
}

layout.add_power = function(self, id, z, file)
  self.add(id, map.merge(cell,
  {
    z=z, path='images/power/'.. file.. '.png'
  }))
end

layout.add_piece = function(self, id, z, file)
  self.add(id, map.merge(cell,
  {
    z=z, path='images/piece/'.. file.. '.png'
  }))
end

layout:add_piece('aura_white',       1, 'ability_white')
layout:add_piece('aura_black',       1, 'ability_black')
layout:add_piece('stone',            2, 'body')
layout:add_piece('white',            3, 'pimp_white')
layout:add_piece('black',            3, 'pimp_black')
layout:add_piece('active_white',     4, 'active_white')
layout:add_piece('active_black',     4, 'active_black')
layout:add_power('Jumpproof',        5, 'jumpproof')
layout:add_power('Movediagonal',     6, 'movediagonal')
layout:add_power('Parasite',         7, 'parasite')
layout:add_power('Parasite_host',    8, 'parasite_host')
layout:add_power('Sphere',           9, 'sphere')
layout:add_power('Scavenger',        10, 'scavenger')

return layout