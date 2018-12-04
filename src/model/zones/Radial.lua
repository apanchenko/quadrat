local Ass       = require 'src.core.Ass'
local vec       = require 'src.core.vec'
local Class      = require 'src.core.Class'
local log       = require 'src.core.log'
local _         = require 'src.core.underscore'

local Radial = Class.Create 'Radial'

-------------------------------------------------------------------------------
function Radial.New(pos)
  Ass.Is(pos, vec)

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

  Ass(tostring(Radial) == 'Radial')
  local radial = Radial.New(vec(3, 3))

  local trues = {vec(2,2), vec(3,2), vec(4,2),
                 vec(2,3),           vec(4,3),
                 vec(2,4), vec(3,4), vec(4,4)}
  Ass(_.all(trues, function(v) return radial:filter(v) end))

  Ass(not radial:filter(vec(0, 0)))
  Ass(not radial:filter(vec(3, 3)))
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Radial, '.filter', vec)

log:wrap(Radial)

return Radial