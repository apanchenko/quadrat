local map       = require 'src.core.map'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'
local wrp       = require 'src.core.wrp'
local playerid  = require 'src.model.playerid'
local Ability   = require 'src.model.Ability'

--
local Piece = obj:extend('Piece')

-- create a piece
function Piece:new(space, pid)
  return obj.new(self,
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
-- add random ability with initial count
function Piece:add_ability()
  self:learn_ability(Ability:new())
end
--
function Piece:use_ability(name)
  self:add_power(self:consume_ability(name, 1)) -- increase power
end
-- add ability
function Piece:learn_ability(abty)
  local count = abty:add_to(self.abilities)
  self.space:notify('set_ability', self.pos, abty:get_id(), count) -- notify
end
-- remove
function Piece:consume_ability(id, count)
  local abty = self.abilities[id]
  ass(abty)
  local count = abty:decrease(self.abilities, count)
  self.space:notify('set_ability', self.pos, id, count) -- notify
  return abty
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
function Piece.wrap()
  wrp.fn(Piece, 'new', {{'Space'}, {'playerid'}})
  wrp.fn(Piece, 'set_pos', {{'pos', Vec}})
  wrp.fn(Piece, 'can_move', {{'from', Vec}, {'to', Vec}})
  wrp.fn(Piece, 'set_color', {{'playerid'}})
  wrp.fn(Piece, 'add_ability', {})
  wrp.fn(Piece, 'learn_ability', {{'abty', Ability}})
  wrp.fn(Piece, 'use_ability', {{'name', typ.str}})
  wrp.fn(Piece, 'consume_ability', {{'name', typ.str}, {'count', typ.num}})
  wrp.fn(Piece, 'add_power', {{'abty', Ability}})
  wrp.fn(Piece, 'decrease_power', {{'name', typ.str}})
end

return Piece