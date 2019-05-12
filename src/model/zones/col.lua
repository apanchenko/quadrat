local obj       = require 'src.luacor.obj'
local ass       = require 'src.luacor.ass'
local log       = require 'src.luacor.log'
local vec       = require 'src.luacor.vec'
local wrp       = require 'src.luacor.wrp'

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
  wrp.wrap_sub_inf(col, 'filter', {'pos', vec})
end

return col