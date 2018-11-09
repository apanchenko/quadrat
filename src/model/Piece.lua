local Type    = require 'src.core.Type'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.Vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local Piece = Type.Create('Piece')

-- create a piece
function Piece.New(event, color)
  Ass.Is(event, 'Event')
  Ass.Is(color, Color)
  local self =
  {
    _event = event,
    _color = color,
    jumpp = false,
    _list = {} -- list of abilities
  }
  return setmetatable(self, Piece)
end

--
function Piece:__tostring()         return 'piece'..tostring(self._pos) end
--
function Piece:color()              return self._color end
--
function Piece:is_jump_protected()  return self.jumpp end

--
function Piece:set_pos(pos)
  self._pos = pos
end

--
function Piece:can_move(space, fr, to)
  local vec = fr - to -- movement vector
  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end

--
function Piece:can_jump(victim)
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
  local name = tostring(ability)
  if self._list[name] then
    self._list[name]:increase(ability.count)
  else
    self._list[name] = ability
  end
  self._event:call('add_ability', self._pos, name) -- notify
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Piece, 'color')
Ass.Wrap(Piece, 'set_pos', Vec)
Ass.Wrap(Piece, 'can_move', 'Space', Vec, Vec)
Ass.Wrap(Piece, 'can_jump', Piece)
Ass.Wrap(Piece, 'add_ability')
Ass.Wrap(Piece, 'learn_ability', 'Ability')

log:trace(Piece)
log:wrap(Piece, 'set_pos', 'add_ability', 'learn_ability')

return Piece