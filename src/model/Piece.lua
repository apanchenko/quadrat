local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.Vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local Piece = setmetatable({}, { __tostring = function() return 'Piece' end })
Piece.__index = Piece

-- create a piece
function Piece.new(space, color, pos)
  ass.Is(space, 'Space')
  ass.Is(color, Color)
  if pos then
    ass.Is(pos, Vec)
  end
  local self =
  {
    _space = space,
    _color = color,
    jumpp = false,
    _pos = pos, -- current position
    _list = {} -- list of abilities
  }
  return setmetatable(self, Piece)
end

--
function Piece:__tostring() return 'piece'..tostring(self._pos) end

--
function Piece:color() return self._color end

--
function Piece:set_pos(pos)
  ass.Is(pos, Vec)
  self._pos = pos
end

--
function Piece:is_jump_protected()
  return self.jumpp
end

--
function Piece:pre_can_move(space, fr, to)
  ass.Is(space, 'Space')
  ass.Is(fr, Vec)
  ass.Is(to, Vec)
end
function Piece:can_move(space, fr, to)
  local vec = fr - to -- movement vector
  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end

--
function Piece:can_jump(victim)
  ass.Is(victim, Piece)
  -- can not kill piece of the same breed
  if victim:color() == self:color() then return false end
  -- victim is protected
  if victim:is_jump_protected()     then return false end
  return true
end

--
function Piece:die()
end

-- ABILITY---------------------------------------------------------------------
-- add random ability
function Piece:add_ability()
  self:learn_ability(Ability.new())
end

-- learn certain ability
function Piece:learn_ability(ability)
  ass.Is(ability, "Ability")
  local name = tostring(ability)
  if self._list[name] then
    self._list[name]:increase(ability.count)
  else
    self._list[name] = ability
  end
  self._space.on_change:call('learn_ability', self._pos, name) -- notify
end

log:trace(Piece)
log:wrap(Piece, 'set_pos', 'add_ability', 'learn_ability')
return Piece