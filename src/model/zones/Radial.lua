local ass       = require 'src.core.ass'
local vec       = require 'src.core.vec'
local Class      = require 'src.core.Class'
local log       = require 'src.core.log'
local _         = require 'src.core.underscore'

local Radial = Class.Create 'Radial'

-------------------------------------------------------------------------------
function Radial.New(pos)
  ass.is(pos, vec)

  local self = setmetatable({}, Radial)
  self.pos = pos
  return self
end

--
function Radial:__tostring()
  return 'radial'.. tostring(self.pos)
end

--
function Radial:filter(pos)
  local distance = (pos - self.pos):length2()
  return distance == 1 or distance == 2
end

-- selftest
function Radial.Test()
  print('test Radial..')

  ass(tostring(Radial) == 'Radial')
  local radial = Radial.New(vec(3, 3))

  local trues = {vec(2,2), vec(3,2), vec(4,2),
                 vec(2,3),           vec(4,3),
                 vec(2,4), vec(3,4), vec(4,4)}
  ass(_.all(trues, function(v) return radial:filter(v) end))

  ass(not radial:filter(vec(0, 0)))
  ass(not radial:filter(vec(3, 3)))
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Radial, ':filter', vec)

log:wrap(Radial)

return Radial