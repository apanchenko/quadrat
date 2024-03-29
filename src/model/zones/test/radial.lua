local ass = require('src.lua-cor.ass')
local vec = require('src.lua-cor.vec')
local arr = require('src.lua-cor.arr')
local radial = require('src.model.zones.radial')

ass.eq(tostring(radial), 'radial')

local rad = radial:new(vec(3, 3))

local trues = arr(vec(2,2), vec(3,2), vec(4,2),
                  vec(2,3), vec(3,3), vec(4,3),
                  vec(2,4), vec(3,4), vec(4,4))
ass(trues:all(function(v) return rad:filter(v) end))

ass(not rad:filter(vec(0, 0)))