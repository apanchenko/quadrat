local obj       = require 'src.core.obj'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'

local Col       = obj:extend('Col')

-- TYPE------------------------------------------------------------------------
function Col:new(pos)
  assert(pos)
  return obj.new(self, {pos = pos})
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
ass.wrap(Col, ':filter', vec)

--log:wrap(Col, 'filter')

return Col