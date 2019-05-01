local ass     = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local power   = require 'src.model.power.power'

local sphere = power:extend('Sphere')

-- can spawn in jade
function sphere:can_spawn()
  return true
end

function sphere:can_move(from, to)
  local w = self.piece.space:width()
  local h = self.piece.space:height()
  local vec = (from - to):abs()
  return (vec.x==0 and vec.y==w-1) or (vec.x==h-1 and vec.y==0)
end

--
function sphere:wrap()
  wrp.fn(sphere, 'can_move', {{'from', 'vec'}, {'to', 'vec'}})
end

--
return sphere