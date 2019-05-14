local obj       = require 'src.lua-cor.obj'
local ass       = require 'src.lua-cor.ass'
local log       = require 'src.lua-cor.log'
local vec       = require 'src.lua-cor.vec'
local wrp       = require 'src.lua-cor.wrp'

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