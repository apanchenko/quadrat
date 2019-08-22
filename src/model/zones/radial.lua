local vec       = require 'src.lua-cor.vec'
local obj       = require 'src.lua-cor.obj'
local log       = require('src.lua-cor.log').get('mode')
local typ       = require 'src.lua-cor.typ'

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
  local wrp       = require 'src.lua-cor.wrp'

  local is   = {'radial', typ.new_is(radial)}
  local ex   = {'radial', typ.new_ex(radial)}

  wrp.fn(log.info, radial, 'new',    is, {'pos', vec})
  wrp.fn(log.info, radial, 'filter', ex, {'pos', vec})
end

return radial