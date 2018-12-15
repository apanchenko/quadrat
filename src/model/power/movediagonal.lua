local ass     = require 'src.core.ass'
local power   = require 'src.model.power.power'

local movediagonal = power:extend('movediagonal')

function movediagonal:can_move(from, to)
  local diff = from - to
  return (diff.x==1 or diff.x==-1) and (diff.y==1 or diff.y==-1)
end

--
ass.wrap(movediagonal, ':can_move', 'vec', 'vec')

--
return movediagonal