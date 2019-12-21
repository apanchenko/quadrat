local power   = require 'src.model.power.power'

local sphere = power:extend('Sphere')

-- can spawn in jade
function sphere:can_spawn()
  return true
end

function sphere:can_move(from, to)
  local w = self.world:width()
  local h = self.world:height()
  local vec = (from - to):abs()
  return (vec.x==0 and vec.y==w-1) or (vec.x==h-1 and vec.y==0)
end

--
function sphere:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local vec = require('src.lua-cor.vec')
  local log = require('src.lua-cor.log').get('mode')

  local ex    = typ.new_ex(sphere)
  wrp.fn(log.trace, sphere, 'can_move', ex, vec, vec)
end

--
return sphere