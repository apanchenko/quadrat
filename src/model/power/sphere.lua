local ass     = require 'src.core.ass'
local power   = require 'src.model.power.power'

local sphere = power:extend('sphere')

function sphere:can_move(from, to)
  local w = self.piece.space:width()
  local h = self.piece.space:height()
  local vec = (from - to):abs()
  return (vec.x==0 and vec.y==w-1) or (vec.x==h-1 and vec.y==0)
end

--
ass.wrap(sphere, ':can_move', 'vec', 'vec')

--
return sphere