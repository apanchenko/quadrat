local ass       = require 'src.lua-cor.ass'
local vec       = require 'src.lua-cor.vec'
local obj       = require 'src.lua-cor.obj'
local log       = require('src.lua-cor.log').get('mode')
local arr       = require 'src.lua-cor.arr'
local wrp       = require 'src.lua-cor.wrp'
local typ     = require 'src.lua-cor.typ'

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

-- selftest
function radial:test()
  log.trace('test radial..')

  ass(tostring(radial) == 'radial')
  local rad = radial:new(vec(3, 3))

  local trues = arr(vec(2,2), vec(3,2), vec(4,2),
                    vec(2,3), vec(3,3), vec(4,3),
                    vec(2,4), vec(3,4), vec(4,4))
  ass(trues:all(function(v) return rad:filter(v) end))

  ass(not rad:filter(vec(0, 0)))
end

-- MODULE ---------------------------------------------------------------------
function radial:wrap()
  local is   = {'radial', typ.new_is(radial)}
  local ex   = {'radial', typ.new_ex(radial)}

  wrp.fn(log.info, radial, 'new',    is, {'pos', vec})
  wrp.fn(log.info, radial, 'filter', ex, {'pos', vec})
end

return radial