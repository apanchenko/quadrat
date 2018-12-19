local ass       = require 'src.core.ass'
local vec       = require 'src.core.vec'
local obj       = require 'src.core.obj'
local log       = require 'src.core.log'
local arr         = require 'src.core.arr'

local Radial = obj:extend('Radial')

-------------------------------------------------------------------------------
function Radial:new(pos)
  return obj.new(self, {pos = pos})
end

--
function Radial:__tostring()
  return 'radial'.. tostring(self.pos)
end

--
function Radial:filter(pos)
  return (pos - self.pos):length2() < 3
end

-- selftest
function Radial.Test()
  print('test Radial..')

  ass(tostring(Radial) == 'Radial')
  local radial = Radial:new(vec(3, 3))

  local trues = {vec(2,2), vec(3,2), vec(4,2),
                 vec(2,3), vec(3,3), vec(4,3),
                 vec(2,4), vec(3,4), vec(4,4)}
  ass(arr.all(trues, function(v) return radial:filter(v) end))

  ass(not radial:filter(vec(0, 0)))
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Radial, ':new', vec)
ass.wrap(Radial, ':filter', vec)

log:wrap(Radial)

return Radial