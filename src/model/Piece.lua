local map     = require 'src.core.map'
local Type    = require 'src.core.Type'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.Vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local Piece = Type.Create 'Piece'

-- create a piece
function Piece.New(space, color)
  Ass.Is(space, 'Space')
  Ass.Is(color, Color)
  local self =
  {
    space = space,
    color = color,
    _list = {}, -- list of abilities
    _powers = {}
  }
  return setmetatable(self, Piece)
end
--
function Piece:__tostring()
  local str = 'piece'
  if self.pos then
    str = str.. tostring(self.pos)
  end
  return str
end
--
function Piece:set_pos(pos)         self.pos = pos end
--
function Piece:can_move(space, fr, to) return (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 end
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
  self.space:notify('add_ability', self.pos, name) -- notify
end
--
function Piece:use_ability(name)
  local ability = self._list[name]
  if ability == nil then
    log:trace(self, ":use_ability, no ability: ".. name)
    return false
  end
  self._list[name] = ability:decrease() -- consume ability
  self.space:notify('remove_ability', self.pos, name) -- notify
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
    p = ability:create_power():apply(self)
    self._powers[name] = p
  end
  self.space:notify('add_power', self.pos, name, p:count()) -- notify
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

-- TRAITS ---------------------------------------------------------------------
--
function Piece:is_jump_protected()
  return map.any(self._powers, function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Piece, 'set_pos', Vec)
Ass.Wrap(Piece, 'can_move', 'Space', Vec, Vec)
Ass.Wrap(Piece, 'add_ability')
Ass.Wrap(Piece, 'learn_ability', Ability)
Ass.Wrap(Piece, 'use_ability', 'string')
Ass.Wrap(Piece, 'add_power', Ability)
Ass.Wrap(Piece, 'remove_power', 'string')

log:trace(Piece)
log:wrap(Piece, 'set_pos', 'add_ability', 'learn_ability', 'use_ability', 'add_power', 'remove_power')
--]]
return Piece