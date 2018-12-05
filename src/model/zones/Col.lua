local Class      = require 'src.core.Class'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'

local Col       = Class.Create 'Col'

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
ass.wrap(Col, '.filter', vec)

--log:wrap(Col, 'filter')

return Col