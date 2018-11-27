local Ass       = require 'src.core.Ass'
local Vec       = require 'src.core.Vec'
local Type      = require 'src.core.Type'
local log       = require 'src.core.log'
local _         = require 'src.core.underscore'

local Radial = Type.Create 'Radial'

-------------------------------------------------------------------------------
function Radial.New(pos)
  Ass.Is(pos, Vec)

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
  local radial = Radial.New(Vec(3, 3))

  local trues = {Vec(2,2), Vec(3,2), Vec(4,2),
                 Vec(2,3),           Vec(4,3),
                 Vec(2,4), Vec(3,4), Vec(4,4)}
  Ass(_.all(trues, function(v) return radial:filter(v) end))

  Ass(not radial:filter(Vec(0, 0)))
  Ass(not radial:filter(Vec(3, 3)))
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Radial, 'filter', Vec)

log:wrap(Radial)

return Radial