local obj       = require 'src.core.obj'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local wrp       = require 'src.core.wrp'

local col       = obj:extend('Col')

-- TYPE------------------------------------------------------------------------
function col:new(pos)
  assert(pos)
  return obj.new(self, {pos = pos})
end

--
function col:filter(pos)
  return pos.x == self.pos.x
end

-- selftest
function col:test()
  print('test Col..')

  assert(tostring(col) == 'Col')
end

-- MODULE ---------------------------------------------------------------------
function col:wrap()
  wrp.fn(col, 'filter', {{'pos', vec}})
end

return col