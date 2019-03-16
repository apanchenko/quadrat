local map       = require 'src.core.map'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'
local wrp       = require 'src.core.wrp'
local cnt       = require 'src.core.cnt'
local playerid  = require 'src.model.playerid'

--
local piece = obj:extend('piece')

-- create a piece
function piece:new(space, pid)
  return obj.new(self,
  {
    space = space,
    pid = pid,
    jades = {}, -- container for jades
    powers = {} -- container for powers
  })
end
--
function piece:__tostring()
  local str = 'piece'
  if self.pos then
    str = str.. tostring(self.pos)
  end
  return str
end
--
function piece:die()
end
--
function piece:set_color(color)
  self.pid = color
  self.space:yell('set_color', self.pos, color) -- notify
end

-- POSITION & MOVE ------------------------------------------------------------
--
function piece:set_pos(pos)
  self.pos = pos
end
--
function piece:can_move(fr, to)
  if (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 then
    return true
  end
  return map.any(self.powers, function(p) return p:can_move(fr, to) end)
end
--
function piece:move_before(fr, to)
  map.each(self.powers, function(p) return p:move_before(fr, to) end)
end
--
function piece:move(fr, to)
  self.pos = to.pos
  map.each(self.powers, function(p) return p:move(fr, to) end)
end
--
function piece:move_after(fr, to)
  self.space:yell('move_piece', to.pos, fr.pos) -- notify
  map.each(self.powers, function(p) return p:move_after(fr, to) end)
end


-- JADE -----------------------------------------------------------------------
-- add jade
function piece:add_jade(jade)
  local res_count = cnt.push(self.jades, jade)
  -- TODO: change event name to 'add_jade'
  self.space:whisper('set_ability', self.pos, jade.id, res_count)
  self.space:yell('piece_has_jade', self.pos, true)
  -- TODO: optimize - make listening powers
  map.each(self.powers, function(p) p:on_add_jade(jade) end)
end

-- split jade and return removed part
function piece:remove_jade(id, count)
  local jade = cnt.pull(self.jades, id, count)
  ass(jade) -- TODO: to wrap prereq
  -- whisper new jade count
  self.space:whisper('set_ability', self.pos, id, cnt.count(self.jades, id))
  -- yell piece has no jades
  if cnt.is_empty(self.jades) then
    self.space:yell('piece_has_jade', self.pos, false)
  end
  return jade
end

-- convert jade to power
function piece:use_jade(id)
  local jade = self:remove_jade(id, 1) -- consume one jade
  local power = jade:use(self) -- convert jade consumed into power
  if power then
    self:add_power(power) -- increase power
  end
end

-- POWER ----------------------------------------------------------------------
--
function piece:add_power(power)
  local count = cnt.push(self.powers, power)
  self.space:yell('add_power', self.pos, power.id, count) -- notify
end

--
function piece:decrease_power(id)
  cnt.pull(self.powers, id, 1)
  self.space:yell('add_power', self.pos, id, cnt.count(self.powers, id)) -- notify
end

-- Completely remove power by id
function piece:remove_power(id)
  cnt.remove(self.powers, id)
  self.space:yell('remove_power', self.pos, id) -- notify
end

--
function piece:any_power(fn)
  map.any(self.powers, fn)
end

-- iterate powers
-- @param fn - callback (power, id)
function piece:each_power(fn)
  map.each(self.powers, fn) 
end


-- TRAITS ---------------------------------------------------------------------
function piece:is_jump_protected()
  return map.any(self.powers, function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
function piece.wrap()
  local id = {'id', typ.str}

  wrp.fn(piece, 'new',        {{'space'}, {'playerid'}},    {log=log.info})
  wrp.fn(piece, 'set_pos',    {{'pos', vec}})
  wrp.fn(piece, 'can_move',   {{'from', vec}, {'to', vec}}, {log=log.info})
  wrp.fn(piece, 'set_color',  {{'playerid'}})
  
  wrp.fn(piece, 'add_jade',   {{'jade'}})
  wrp.fn(piece, 'remove_jade',{id, {'count', typ.num}})
  wrp.fn(piece, 'use_jade',   {id})

  wrp.fn(piece, 'add_power',  {{'power'}})
  wrp.fn(piece, 'remove_power', {id})
  wrp.fn(piece, 'decrease_power', {{'name', typ.str}})
end

function piece.test()
  ass.eq(typ.str.is(nil), false)
end

return piece