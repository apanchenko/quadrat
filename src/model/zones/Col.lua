local Type      = require 'src.core.Type'
local Ass       = require 'src.core.Ass'
local Col       = Type.Create 'Col'
local log       = require 'src.core.log'

-- TYPE------------------------------------------------------------------------
function Col.New(pos)
  assert(pos)

  local self = setmetatable({}, Col)
  self.pos = pos
  return self
end

--
function Col:filter(pos)
  return pos.x == self.pos.x
end

-- selftest
function Col.Test()
  print('test Col..')

  assert(tostring(Col) == 'Col')
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Col, 'filter', 'Vec')

--log:wrap(Col, 'filter')

return Col