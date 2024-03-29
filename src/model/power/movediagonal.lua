local power   = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('mode')

local movediagonal = power:extend('Movediagonal')

-- can spawn in jade
function movediagonal:can_spawn()
  return true
end

--
function movediagonal:can_move(from, to)
  local diff = from - to
  return (diff.x==1 or diff.x==-1) and (diff.y==1 or diff.y==-1)
end

-- module
function movediagonal:wrap()
  local typ = require('src.lua-cor.typ')
  local wrp = require('src.lua-cor.wrp')
  local vec = require('src.lua-cor.vec')

  local ex = typ.new_ex(movediagonal)
  wrp.fn(log.trace, movediagonal, 'can_move', ex, vec, vec)
end

--
return movediagonal