local wrp     = require 'src.lua-cor.wrp'
local power   = require 'src.model.power.power'

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
  wrp.wrap_sub_trc(movediagonal, 'can_move', {'from', 'vec'}, {'to', 'vec'})
end

--
return movediagonal