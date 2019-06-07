local ass       = require 'src.lua-cor.ass'
local obj       = require 'src.lua-cor.obj'
local log       = require('src.lua-cor.log').get('mode')
local vec       = require 'src.lua-cor.vec'
local wrp     = require 'src.lua-cor.wrp'
local typ     = require 'src.lua-cor.typ'

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
  local ris   = {'row', typ.new_is(row)}
  local rex   = {'row', typ.new_ex(row)}

  wrp.wrap_stc(log.info, row, 'new',    ris, {'pos', vec})
  wrp.wrap_stc(log.info, row, 'filter', rex, {'pos', vec})
end


return row