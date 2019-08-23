local obj       = require 'src.lua-cor.obj'
local vec       = require 'src.lua-cor.vec'

local row = obj:extend('Row')

--
function row:new(pos)
  return obj.new(self, {pos = pos})
end

--
function row:filter(pos)
  return pos.y == self.pos.y
end

-- MODULE ---------------------------------------------------------------------
function row:wrap()
  local log       = require('src.lua-cor.log').get('mode')
  local wrp     = require 'src.lua-cor.wrp'
  local typ     = require 'src.lua-cor.typ'
  local rex   = typ.new_ex(row)

  wrp.fn(log.info, row, 'new',    row, vec)
  wrp.fn(log.info, row, 'filter', rex, vec)
end


return row