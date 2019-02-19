local ass       = require 'src.core.ass'
local obj       = require 'src.core.obj'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local wrp     = require 'src.core.wrp'

local Row = obj:extend('Row')

--
function Row:new(pos)
  return obj.new(self, {pos = pos})
end

--
function Row:filter(pos)
  return pos.y == self.pos.y
end

-- selftest
function Row.Test()
  print('test Row..')

  assert(tostring(Row) == 'Row')
end

-- MODULE ---------------------------------------------------------------------
function Row.wrap()
  wrp.fn(Row, 'new', {{'pos', vec}})
  wrp.fn(Row, 'filter', {{'pos', vec}})
end


return Row