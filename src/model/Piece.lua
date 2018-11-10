local Type    = require 'src.core.Type'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.Vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local Piece = Type.Create 'Piece'

-- create a piece
function Piece.New(event, color)
  Ass.Is(event, 'Event')
  Ass.Is(color, Color)
  local self =
  {
    _event = event,
    _color = color,
    jumpp = false,
    _list = {}, -- list of abilities
    _powers = {}
  }
  return setmetatable(self, Piece)
end
--
function Piece:__tostring()
  local str = 'piece'
  if self._pos then
    str = str.. tostring(self._pos)
  end
  return str
end
--
function Piece:color()              return self._color end
--
function Piece:is_jump_protected()  return self.jumpp end
--
function Piece:pos()                return self._pos end
--
function Piece:set_pos(pos)         self._pos = pos end
--
function Piece:can_move(space, fr, to) return (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 end
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
  self:learn_ability(Ability.New())
end
--
function Piece:learn_ability(ability)
  local name = tostring(ability)
  if self._list[name] then
    self._list[name]:increase(ability.count)
  else
    self._list[name] = ability
  end
  self._event:call('add_ability', self._pos, name) -- notify
end
--
function Piece:use_ability(name)
  local ability = self._list[name]
  if ability == nil then
    log:trace(self, ":use_ability, no ability: ".. name)
    return false
  end
  self._list[name] = ability:decrease() -- consume ability
  self._event:call('consume_ability', self._pos, name, ability:get_count()) -- notify
  self:add_power(ability) -- increase power
end

-- POWER ----------------------------------------------------------------------
--
function Piece:add_power(ability)
  local name = tostring(ability)
  local p = self._powers[name]
  if p then
    p:increase()
  else
    self._powers[name] = ability:create_power():apply(self)
  end
end
--
function Piece:remove_power(name)
  local p = self._powers[name]
  if p then
    if not p:decrease() then
      self._powers[name] = nil
    end
  end
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Piece, 'color')
Ass.Wrap(Piece, 'pos')
Ass.Wrap(Piece, 'set_pos', Vec)
Ass.Wrap(Piece, 'can_move', 'Space', Vec, Vec)
Ass.Wrap(Piece, 'can_jump', Piece)
Ass.Wrap(Piece, 'add_ability')
Ass.Wrap(Piece, 'learn_ability', Ability)
Ass.Wrap(Piece, 'use_ability', 'string')
Ass.Wrap(Piece, 'add_power', Ability)
Ass.Wrap(Piece, 'remove_power', 'string')

log:trace(Piece)
log:wrap(Piece, 'set_pos', --[['add_ability', 'learn_ability',--]] 'use_ability', 'add_power', 'remove_power')

return Piece