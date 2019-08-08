local map       = require 'src.lua-cor.map'
local obj       = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local vec       = require 'src.lua-cor.vec'
local wrp       = require 'src.lua-cor.wrp'
local cnt       = require 'src.lua-cor.cnt'
local playerid  = require 'src.model.playerid'

--
local piece = obj:extend('piece')

-- interface
function piece:wrap()
  local pis   = {'piece', typ.new_is(piece)}
  local pex   = {'piece', typ.new_ex(piece)}
  local space = {'space'}
  local pid   = {'playerid'}
  local jade  = {'jade'}
  local from  = {'from', vec}
  local to    = {'to', vec}
  local id    = {'id', typ.str}
  local count = {'count', typ.num}
  local power = {'power'}
  local name  = {'name', typ.str}
  local fspot = {'fr', 'spot'}
  local tspot = {'to', 'spot'}

  -- piece
  wrp.fn(log.trace, piece, 'new',            pis, space, pid)
  wrp.fn(log.trace, piece, 'set_color',      pex, pid)
  wrp.fn(log.trace, piece, 'die',            pex)

  -- position
  --wrp.fn(piece, 'set_pos',        { {'to', type={name='vec', is=isvec}} }      )
  wrp.fn(log.info, piece, 'can_move',        pex, from,  to)
  wrp.fn(log.trace, piece, 'move_before',    pex, fspot, tspot)
  wrp.fn(log.trace, piece, 'move',           pex, fspot, tspot)
  wrp.fn(log.trace, piece, 'move_after',     pex, fspot, tspot)
  
  -- jades
  wrp.fn(log.trace, piece, 'add_jade',       pex, jade)
  wrp.fn(log.trace, piece, 'remove_jade',    pex, id, count)
  wrp.fn(log.trace, piece, 'use_jade',       pex, id)
  wrp.fn(log.trace, piece, 'each_jade',      pex, {'fn', typ.fun})
  wrp.fn(log.trace, piece, 'clear_jades',    pex)

  -- powers
  wrp.fn(log.trace, piece, 'add_power',      pex, power)
  wrp.fn(log.trace, piece, 'remove_power',   pex, id)
  wrp.fn(log.trace, piece, 'decrease_power', pex, name)
end

-- create a piece
function piece:new(space, pid)
  return obj.new(self,
  {
    space = space,
    pid = pid,
    jades = cnt:new(), -- container for jades
    powers = cnt:new() -- container for powers
  })
end
--
function piece:__tostring()
  local str = 'piece{'.. tostring(self.pid)
  if self.pos then
    str = str.. ','.. tostring(self.pos)
  end
  return str.. '}'
end
--
function piece:die()
end
--
function piece:set_color(color)
  self.pid = color
  self.space:yell('piece_set_color', self.pos, color) -- notify
end
--
function piece:get_pid()
  return self.pid
end

-- POSITION & MOVE ------------------------------------------------------------
--
function piece:set_pos_wrap_before(pos)
  ass(pos==nil or typ.is(pos, vec))
end
function piece:set_pos(pos)
  self.pos = pos
end
--
function piece:can_move(fr, to)
  if (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 then
    return true
  end
  return self.powers:any(function(p) return p:can_move(fr, to) end)
end
--
function piece:move_before(fr, to)
  self.powers:each(function(p) return p:move_before(fr, to) end)
end
--
function piece:move(fr, to)
  self.pos = to.pos
  self.powers:each(function(p) return p:move(fr, to) end)
end
--
function piece:move_after(fr, to)
  self.space:yell('move_piece', to.pos, fr.pos) -- notify
  self.powers:each(function(p) return p:move_after(fr, to) end)
end


-- JADE -----------------------------------------------------------------------
-- add jade
function piece:add_jade(jade)
  local res_count = self.jades:push(jade)
  -- TODO: change event name to 'add_jade'
  self.space:whisper('set_ability', self.pos, jade.id, res_count)
  self.space:yell('piece_has_jade', self.pos, true)
  -- TODO: optimize - make listening powers
  self.powers:each(function(p) p:on_add_jade(jade) end)
end

-- split jade and return removed part
function piece:remove_jade(id, count)
  local jade = self.jades:pull(id, count)
  ass(jade) -- TODO: to wrap prereq
  -- whisper new jade count
  self.space:whisper('set_ability', self.pos, id, self.jades:count(id))
  -- yell piece has no jades
  if self.jades:is_empty() then
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

-- iterate jades
function piece:each_jade(fn)
  self.jades:each(fn)
end

-- remove all jades
function piece:clear_jades()
  if self.jades:is_empty() then
    return -- nothing to do
  end
  self:each_jade(function(jade)
    self.space:whisper('set_ability', self.pos, jade.id, 0)
  end)
  self.space:yell('piece_has_jade', self.pos, false)
  self.jades:clear()
end

-- POWER ----------------------------------------------------------------------
--
function piece:add_power(power)
  local count = self.powers:push(power)
  self.space:yell('piece_add_power', self.pos, power.id, count) -- notify
end

--
function piece:decrease_power(id)
  self.powers:pull(id, 1)
  self.space:yell('piece_add_power', self.pos, id, self.powers:count(id)) -- notify
end

-- Completely remove power by id
function piece:remove_power(id)
  self.powers:remove(id)
  self.space:yell('remove_power', self.pos, id) -- notify
end

--
function piece:any_power(fn)
  self.powers:any(fn)
end

-- iterate powers
-- @param fn - callback (power, id)
function piece:each_power(fn)
  self.powers:each(fn) 
end


-- TRAITS ---------------------------------------------------------------------
function piece:is_jump_protected()
  return self.powers:any(function(p) return p.is_jump_protected == true end)
end

-- MODULE ---------------------------------------------------------------------
function piece:test()
  local i = cnt:new()
  ass(i:is_empty())

  local copy = function(self)
    return {id=self.id, count=self.count, copy=self.copy}
  end
  local res = i:push({id='b', count=2, copy=copy})
  res = i:push({id='b', count=3, copy=copy})
  ass.eq(res, 5)

end

return piece