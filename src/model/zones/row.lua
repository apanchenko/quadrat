local ass       = require 'src.core.ass'
local obj       = require 'src.core.obj'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local wrp     = require 'src.core.wrp'

local row = obj:extend('row')

--
function row:new(pos)
  return obj.new(self, {pos = pos})
end

--
function row:filter(pos)
  return pos.y == self.pos.y
end

-- selftest
function row.Test()
  print('test row..')

  assert(tostring(row) == 'row')
end

-- MODULE ---------------------------------------------------------------------
function row.wrap()
  wrp.fn(row, 'new', {{'pos', vec}})
  wrp.fn(row, 'filter', {{'pos', vec}})
end


return row