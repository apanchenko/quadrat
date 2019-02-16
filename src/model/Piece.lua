local map       = require 'src.core.map'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'
local wrp       = require 'src.core.wrp'
local playerid  = require 'src.model.playerid'

--
local Piece = obj:extend('Piece')

-- create a piece
function Piece:new(space, pid)
  return obj.new(self,
  {
    space = space,
    pid = pid,
    jades = {}, -- map of jades
    powers = {} -- map of powers
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


-- JADE -----------------------------------------------------------------------
-- add jade
function Piece:add_jade(jade)
  local res_count = jade:add_to(self.jades)
  -- TODO: change event name to 'add_jade'
  self.space:notify('set_ability', self.pos, jade.id, res_count)
  -- TODO: optimize - make listening powers
  map.each(self.powers, function(p) p:on_add_jade(jade) end)
end

-- split jade and return removed part
function Piece:remove_jade(id, count)
  local jade = self.jades[id]
  ass(jade) -- TODO: to wrap prereq

  self.jades[id] = jade:split(count)
  if self.jades[id] then
    self.space:notify('set_ability', self.pos, id, self.jades[id].count)
  else
    self.space:notify('set_ability', self.pos, id, 0)
  end

  return jade
end

-- convert jade to power
function Piece:use_jade(id)
  local jade = self:remove_jade(id, 1) -- consume one jade
  local power = jade:use(self) -- convert jade consumed into power
  if power then
    self:add_power(power) -- increase power
  end
end


-- POWER ----------------------------------------------------------------------
--
function Piece:add_power(power)
  local count = power:add_to(self.powers)
  log:info(self, 'add_power', self.pos, power.type, count)
  self.space:notify('add_power', self.pos, power.type, count) -- notify
end

--
function Piece:decrease_power(id)
  local power = self.powers[id]:decrease()
  self.powers[id] = power
  if power then
    self.space:notify('add_power', self.pos, id, power:get_count()) -- notify
  else
    self.space:notify('add_power', self.pos, id, 0) -- notify
  end
end

--
function Piece:any_power(fn)
  map.any(self.powers, fn)
end

-- TRAITS ---------------------------------------------------------------------
function Piece:is_jump_protected()
  return map.any(self.powers, function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
function Piece.wrap()
  wrp.fn(Piece, 'new',        {{'Space'}, {'playerid'}},    {log=log.info})
  wrp.fn(Piece, 'set_pos',    {{'pos', Vec}})
  wrp.fn(Piece, 'can_move',   {{'from', Vec}, {'to', Vec}}, {log=log.info})
  wrp.fn(Piece, 'set_color',  {{'playerid'}})
  
  wrp.fn(Piece, 'add_jade',   {{'jade'}})
  wrp.fn(Piece, 'remove_jade',{{'id', typ.str}, {'count', typ.num}})
  wrp.fn(Piece, 'use_jade',   {{'id', typ.str}})

  wrp.fn(Piece, 'add_power',  {{'power'}})
  wrp.fn(Piece, 'decrease_power', {{'name', typ.str}})
end

function Piece.test()
  ass.eq(typ.str.is(nil), false)
end

return Piece