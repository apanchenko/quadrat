local map     = require 'src.core.map'
local Class   = require 'src.core.Class'
local types   = require 'src.core.types'
local Ass     = require 'src.core.Ass'
local log     = require 'src.core.log'
local Vec     = require 'src.core.vec'
local Color   = require 'src.model.Color'
local Ability = require 'src.model.Ability'

--
local Piece = Class.Create 'Piece'

-- create a piece
function Piece.New(space, color)
  Ass.Is(space, 'Space')
  Ass.Is(color, Color)
  local self =
  {
    space = space,
    color = color,
    abilities = {}, -- list of abilities
    powers = {}
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
function Piece:can_move(space, fr, to)
  if (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 then
    return true
  end
  return map.any(self.powers, function(p) return p:can_move(fr, to) end)
end
--
function Piece:die()
end
--
function Piece:set_color(color)
  self.color = color
  self.space:notify('set_color', self.pos, color) -- notify
end

-- ABILITY---------------------------------------------------------------------
-- add random ability
function Piece:add_ability()
  self:learn_ability(Ability.New())
end
--
function Piece:learn_ability(ability)
  local name = tostring(ability)
  if self.abilities[name] then
    self.abilities[name]:increase(ability.count)
  else
    self.abilities[name] = ability
  end
  self.space:notify('add_ability', self.pos, name) -- notify
end
--
function Piece:use_ability(name)
  local ability = self.abilities[name]
  if ability == nil then
    log:trace(self, ":use_ability, no ability: ".. name)
    return false
  end
  self.abilities[name] = ability:decrease() -- consume ability
  self.space:notify('remove_ability', self.pos, name) -- notify
  self:add_power(ability) -- increase power
end

-- POWER ----------------------------------------------------------------------
function Piece:add_power(ability)
  local name = tostring(ability)
  local p = self.powers[name]
  if p then
    p:increase()
  else
    p = ability:create_power(self)
    self.powers[name] = p
  end

  if p then
    self.space:notify('add_power', self.pos, name, 1) -- notify
  end
end
--
function Piece:remove_power(name)
  local p = self.powers[name]
  if p then
    if not p:decrease() then
      self.powers[name] = nil
    end
  end
end

-- TRAITS ---------------------------------------------------------------------
function Piece:is_jump_protected()
  return map.any(self.powers, function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Piece, '.New', 'Space', 'Color')
Ass.Wrap(Piece, ':set_pos', Vec)
Ass.Wrap(Piece, ':can_move', 'Space', Vec, Vec)
Ass.Wrap(Piece, ':set_color', 'Color')
Ass.Wrap(Piece, ':add_ability')
Ass.Wrap(Piece, ':learn_ability', Ability)
Ass.Wrap(Piece, ':use_ability', types.str)
Ass.Wrap(Piece, ':add_power', Ability)
Ass.Wrap(Piece, ':remove_power', types.str)

log:wrap(Piece, 'set_pos', 'set_color', 'add_ability', 'learn_ability', 'use_ability', 'add_power', 'remove_power')

return Piece