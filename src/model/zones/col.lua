local obj       = require('src.lua-cor.obj')
local vec       = require('src.lua-cor.vec')

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


-- MODULE ---------------------------------------------------------------------
function col:wrap()
  local log       = require('src.lua-cor.log').get('mode')
  local wrp       = require('src.lua-cor.wrp')
  local typ     = require('src.lua-cor.typ')
  local ex   = typ.new_ex(col)

  wrp.fn(log.info, col, 'filter', ex, vec)
end

return col