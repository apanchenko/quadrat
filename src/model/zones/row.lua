local ass       = require 'src.luacor.ass'
local obj       = require 'src.luacor.obj'
local log       = require 'src.luacor.log'
local vec       = require 'src.luacor.vec'
local wrp     = require 'src.luacor.wrp'

local row = obj:extend('Row')

--
function row:new(pos)
  return obj.new(self, {pos = pos})
end

--
function row:filter(pos)
  return pos.y == self.pos.y
end

-- selftest
function row:test()
  print('test row..')

  assert(tostring(row) == 'Row')
end

-- MODULE ---------------------------------------------------------------------
function row:wrap()
  wrp.wrap_tbl_inf(row, 'new',    {'pos', vec})
  wrp.wrap_sub_inf(row, 'filter', {'pos', vec})
end


return row