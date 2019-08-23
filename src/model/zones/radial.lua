local vec       = require('src.lua-cor.vec')
local obj       = require('src.lua-cor.obj')

local radial = obj:extend('radial')

-------------------------------------------------------------------------------
function radial:new(pos)
  return obj.new(self, {pos = pos})
end

--
function radial:__tostring()
  return 'radial'.. tostring(self.pos)
end

--
function radial:filter(pos)
  return (pos - self.pos):length2() < 3
end

-- MODULE ---------------------------------------------------------------------
function radial:wrap()
  local wrp       = require('src.lua-cor.wrp')
  local typ       = require('src.lua-cor.typ')
  local log       = require('src.lua-cor.log').get('mode')

  local ex   = typ.new_ex(radial)

  wrp.fn(log.info, radial, 'new',    radial, vec)
  wrp.fn(log.info, radial, 'filter', ex, vec)
end

return radial