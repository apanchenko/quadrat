local ass       = require 'src.lua-cor.ass'
local vec       = require 'src.lua-cor.vec'
local obj       = require 'src.lua-cor.obj'
local log       = require 'src.lua-cor.log'
local arr       = require 'src.lua-cor.arr'
local wrp       = require 'src.lua-cor.wrp'

local radial = obj:extend('radial')

-------------------------------------------------------------------------------
function radial:new(pos)
  return obj.new(self, {pos = pos})
end

--
function radial:__tostring()
  return 'radial'.. tostring(self.pos)
end

--
function radial:filter(pos)
  return (pos - self.pos):length2() < 3
end

-- selftest
function radial:test()
  log:trace('test radial..')

  ass(tostring(radial) == 'radial')
  local rad = radial:new(vec(3, 3))

  local trues = arr(vec(2,2), vec(3,2), vec(4,2),
                    vec(2,3), vec(3,3), vec(4,3),
                    vec(2,4), vec(3,4), vec(4,4))
  ass(trues:all(function(v) return rad:filter(v) end))

  ass(not rad:filter(vec(0, 0)))
end

-- MODULE ---------------------------------------------------------------------
function radial:wrap()
  wrp.wrap_tbl_inf(radial, 'new',    {'pos', vec})
  wrp.wrap_sub_inf(radial, 'filter', {'pos', vec})
end

return radial