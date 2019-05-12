local ass       = require 'src.core.ass'
local vec       = require 'src.core.vec'
local obj       = require 'src.core.obj'
local log       = require 'src.core.log'
local arr       = require 'src.core.arr'
local wrp       = require 'src.core.wrp'

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
  print('test radial..')

  ass(tostring(radial) == 'radial')
  local rad = radial:new(vec(3, 3))

  local trues = {vec(2,2), vec(3,2), vec(4,2),
                 vec(2,3), vec(3,3), vec(4,3),
                 vec(2,4), vec(3,4), vec(4,4)}
  ass(arr.all(trues, function(v) return rad:filter(v) end))

  ass(not rad:filter(vec(0, 0)))
end

-- MODULE ---------------------------------------------------------------------
function radial:wrap()
  wrp.wrap_tbl_inf(radial, 'new',    {'pos', vec})
  wrp.wrap_sub_inf(radial, 'filter', {'pos', vec})
end

return radial