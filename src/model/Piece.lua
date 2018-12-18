local map       = require 'src.core.map'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'
local playerid  = require 'src.model.playerid'
local Ability   = require 'src.model.Ability'

--
local Piece = obj:extend('Piece')

-- create a piece
local obj_create = obj.create
function Piece:create(space, pid)
  return obj_create(self,
  {
    space = space,
    pid = pid,
    abilities = {}, -- list of abilities
    powers = {}
  })
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
function Piece:die()
end
--
function Piece:set_color(color)
  self.pid = color
  self.space:notify('set_color', self.pos, color) -- notify
end

-- POSITION & MOVE ------------------------------------------------------------
--
function Piece:set_pos(pos)
  self.pos = pos
end
--
function Piece:can_move(fr, to)
  if (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 then
    return true
  end
  return map.any(self.powers, function(p) return p:can_move(fr, to) end)
end
--
function Piece:move_before(fr, to)
  map.each(self.powers, function(p) return p:move_before(fr, to) end)
end
--
function Piece:move(fr, to)
  self.pos = to.pos
  map.each(self.powers, function(p) return p:move(fr, to) end)
end
--
function Piece:move_after(fr, to)
  self.space:notify('move_piece', to.pos, fr.pos) -- notify
  map.each(self.powers, function(p) return p:move_after(fr, to) end)
end

-- ABILITY---------------------------------------------------------------------
-- add random ability
function Piece:add_ability()
  self:learn_ability(Ability:create())
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
  local power = self.powers[name]
  if power then
    power:increase()
  else
    power = ability:create_power(self)
    self.powers[name] = power
  end

  if power then
    self.space:notify('add_power', self.pos, name, power:get_count()) -- notify
  end
end
--
function Piece:decrease_power(name)
  local power = self.powers[name]
  if power then
    self.powers[name] = power:decrease()
  end
  self.space:notify('add_power', self.pos, name, power:get_count()) -- notify
end

-- TRAITS ---------------------------------------------------------------------
function Piece:is_jump_protected()
  return map.any(self.powers, function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Piece, ':create', 'Space', 'playerid')
ass.wrap(Piece, ':set_pos', Vec)
ass.wrap(Piece, ':can_move', Vec, Vec)
ass.wrap(Piece, ':set_color', 'playerid')
ass.wrap(Piece, ':add_ability')
ass.wrap(Piece, ':learn_ability', Ability)
ass.wrap(Piece, ':use_ability', typ.str)
ass.wrap(Piece, ':add_power', Ability)
ass.wrap(Piece, ':decrease_power', typ.str)

log:wrap(Piece, 'set_pos', 'set_color', 'add_ability', 'learn_ability', 'use_ability', 'add_power', 'decrease_power')

return Piece