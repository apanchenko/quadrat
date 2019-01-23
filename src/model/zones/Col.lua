local obj       = require 'src.core.obj'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local wrp       = require 'src.core.wrp'

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
function Col.wrap()
  wrp.fn(Col, ':filter', {{'pos', vec}})
end

return Col