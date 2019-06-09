local obj       = require 'src.lua-cor.obj'
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local vec       = require 'src.lua-cor.vec'
local wrp       = require 'src.lua-cor.wrp'
local typ     = require 'src.lua-cor.typ'

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
  log.trace('test Col..')

  assert(tostring(col) == 'Col')
end

-- MODULE ---------------------------------------------------------------------
function col:wrap()
  local is   = {'col', typ.new_is(col)}
  local ex   = {'col', typ.new_ex(col)}

  wrp.fn(log.info, col, 'filter', ex, {'pos', vec})
end

return col