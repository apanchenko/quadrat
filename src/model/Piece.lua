local ass   = require 'src.core.ass'
local Vec   = require 'src.core.vec'
local Color = require 'src.model.Color'

-- piece is a set of qualities such as color, jumpproof etc.
local Piece = {}
Piece.typename = 'Piece'
Piece.__index = Piece

-- indeces
local COLOR = 1
local JUMPP = 2

-- create a piece
function Piece.new(color)
  Color.ass(color)

  local self = {}
  self[COLOR] = color
  self[JUMPP] = false
  return setmetatable(self, Piece)
end

--
function Piece:color()
  return self[COLOR]
end

--
function Piece:is_jump_protected()
  return self[JUMPP]
end

--
function Piece:can_move(space, fr, to)
  ass.is(space, 'Space')
  ass.is(fr, Vec)
  ass.is(to, Vec)
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