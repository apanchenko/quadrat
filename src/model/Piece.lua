local ass   = require 'src.core.ass'
local Vec   = require 'src.core.Vec'
local Color = require 'src.model.Color'

-- piece is a set of qualities such as color, jumpproof etc.
local Piece = {}
Piece.typename = 'Piece'
Piece.__index = Piece

-- create a piece
function Piece.new(color, pos)
  Color.ass(color)
  if pos then
    ass.is(pos, Vec)
  end
  local self =
  {
    _color = color,
    jumpp = false,
    pos = pos
  }
  return setmetatable(self, Piece)
end

--
function Piece:color() return self._color end

--
function Piece:is_jump_protected()
  return self.jumpp
end

--
function Piece:pre_can_move(space, fr, to)
  ass.is(space, 'Space')
  ass.is(fr, Vec)
  ass.is(to, Vec)
end
function Piece:can_move(space, fr, to)
  local vec = fr - to -- movement vector
  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end

--
function Piece:can_jump(victim)
  ass.is(victim, Piece)
  -- can not kill piece of the same breed
  if victim:color() == self:color() then return false end
  -- victim is protected
  if victim:is_jump_protected()     then return false end
  return true
end

--
function Piece:die()
end

-- true if model is valid
-- todo
function Piece:valid()
  if type(self) ~= 'table' then
    return false
  end
  return true
end

return Piece