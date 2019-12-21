local obj       = require('src.lua-cor.obj')
local ass       = require('src.lua-cor.ass')
local log       = require('src.lua-cor.log').get('mode')
local vec       = require('src.lua-cor.vec')
local cnt       = require('src.lua-cor.cnt')
local typ       = require('src.lua-cor.typ')

--
local Piece = obj:extend('Piece')

-- interface
function Piece:wrap()
  local wrp       = require('src.lua-cor.wrp')
  local space     = require('src.model.space.space')
  local jade      = require('src.model.jade')
  local power     = require('src.model.power.power')
  local spot      = require('src.model.spot.spot')
  local playerid  = require('src.model.playerid')

  local ex   = typ.new_ex(Piece)

  -- Piece
  wrp.fn(log.trace, Piece, 'new',            Piece, space, playerid)
  wrp.fn(log.trace, Piece, 'set_color',      ex, playerid)
  wrp.fn(log.trace, Piece, 'die',            ex)

  -- position
  wrp.fn(log.info,  Piece, 'get_pos',        ex)
  --wrp.fn(Piece, 'set_pos',        { {'to', type={name='vec', is=isvec}} }      )
  wrp.fn(log.info,  Piece, 'on_kill',        ex, typ.new_is(Piece))
  wrp.fn(log.info,  Piece, 'can_move',       ex, vec, vec)
  wrp.fn(log.trace, Piece, 'move_before',    ex, spot, spot)
  wrp.fn(log.trace, Piece, 'move',           ex, spot, spot)
  wrp.fn(log.trace, Piece, 'move_after',     ex, spot, spot)

  -- jades
  wrp.fn(log.trace, Piece, 'add_jade',       ex, jade)
  wrp.fn(log.trace, Piece, 'remove_jade',    ex, typ.str, typ.num)
  wrp.fn(log.trace, Piece, 'use_jade',       ex, typ.str)
  wrp.fn(log.trace, Piece, 'each_jade',      ex, typ.fun)
  wrp.fn(log.trace, Piece, 'clear_jades',    ex)

  -- powers
  wrp.fn(log.trace, Piece, 'count_power',    ex, typ.str)
  wrp.fn(log.trace, Piece, 'add_power',      ex, power)
  wrp.fn(log.trace, Piece, 'remove_power',   ex, typ.str)
  wrp.fn(log.trace, Piece, 'decrease_power', ex, typ.str)
end

-- private
local _world = {}

-- create a Piece
function Piece:new(world, pid)
  self = obj.new(self,
  {
    pid = pid,
    jades_cnt = cnt:new(), -- container for jades
    powers = cnt:new() -- container for powers
  })
  self[_world] = world
  return self
end

--
function Piece:__tostring()
  local str = 'Piece{'.. tostring(self.pid)
  if self.pos then
    str = str.. ','.. tostring(self.pos)
  end
  return str.. '}'
end

--
function Piece:die()
end

--
function Piece:set_color(color)
  self.pid = color
  self[_world].on_set_color(self.pos, color) -- notify
end

--
function Piece:get_pid()
  return self.pid
end

-- POSITION & MOVE ------------------------------------------------------------
--
function Piece:set_pos_wrap_before(pos)
  ass(pos==nil or typ.is(pos, vec))
end
function Piece:set_pos(pos)
  self.pos = pos
end

--
function Piece:get_pos()
  return self.pos
end

-- kill another Piece
function Piece:on_kill(victim_piece)
  self.powers:each(function(p)
    if p.on_kill then
      return p:on_kill(victim_piece)
    end
  end)
end

--
function Piece:can_move(fr, to)
  if (fr.x==to.x or fr.y==to.y) and (fr - to):length2() == 1 then
    return true
  end
  return self.powers:any(function(p) return p:can_move(fr, to) end)
end
--
function Piece:move_before(fr, to)
  self.powers:each(function(p) return p:move_before(fr, to) end)
end
--
function Piece:move(fr, to)
  self.pos = to.pos
  self.powers:each(function(p) return p:move(fr, to) end)
end
--
function Piece:move_after(fr, to)
  self[_world].on_move_piece(to.pos, fr.pos) -- notify
  self.powers:each(function(p) return p:move_after(fr, to) end)
end


-- JADE -----------------------------------------------------------------------
-- add jade
function Piece:add_jade(jade)
  local res_count = self.jades_cnt:push(jade)
  -- TODO: change event name to 'add_jade'
  self[_world].on_set_ability(self.pos, jade.id, res_count)
  -- TODO: optimize - make listening powers
  self.powers:each(function(p) p:on_add_jade(jade) end)
end

-- split jade and return removed part
function Piece:remove_jade(id, count)
  local jade = self.jades_cnt:pull(id, count)
  ass(jade) -- TODO: to wrap prereq
  self[_world].on_set_ability(self.pos, id, self.jades_cnt:count(id))
  return jade
end

-- convert jade to power
function Piece:use_jade(id)
  local jade = self:remove_jade(id, 1) -- consume one jade
  local power = jade:use(self, self[_world]) -- convert jade consumed into power
  if power then
    self:add_power(power) -- increase power
  end
end

-- iterate jades
function Piece:each_jade(fn)
  self.jades_cnt:each(fn)
end

-- remove all jades
function Piece:clear_jades()
  if self.jades_cnt:is_empty() then
    return -- nothing to do
  end
  self:each_jade(function(jade)
    self[_world].on_set_ability(self.pos, jade.id, 0)
  end)
  self.jades_cnt:clear()
end

-- POWER ----------------------------------------------------------------------
function Piece:count_power(id)
  return self.powers:count(id)
end

--
function Piece:add_power(power)
  local count = self.powers:push(power)
  self[_world].on_add_power(self.pos, power.id, count) -- notify
end

--
function Piece:decrease_power(id)
  self.powers:pull(id, 1)
  self[_world].on_add_power(self.pos, id, self.powers:count(id)) -- notify
end

-- Completely remove power by id
function Piece:remove_power(id)
  self.powers:remove(id)
  self[_world].on_remove_power(self.pos, id) -- notify
end

--
function Piece:any_power(fn)
  return self.powers:any(fn)
end

-- iterate powers
-- @param fn - callback (power, id)
function Piece:each_power(fn)
  self.powers:each(fn)
end


-- TRAITS ---------------------------------------------------------------------
function Piece:is_jump_protected()
  return self.powers:any(function(p) return p.is_jump_protected == true end)
end

return Piece