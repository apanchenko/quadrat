local ass       = require 'src.lua-cor.ass'
local obj       = require 'src.lua-cor.obj'
local log       = require('src.lua-cor.log').get('')
local vec       = require 'src.lua-cor.vec'
local wrp     = require 'src.lua-cor.wrp'

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
  log.trace('test row..')

  assert(tostring(row) == 'Row')
end

-- MODULE ---------------------------------------------------------------------
function row:wrap()
  wrp.wrap_tbl(log.info, row, 'new',    {'pos', vec})
  wrp.wrap_sub(log.info, row, 'filter', {'pos', vec})
end


return row