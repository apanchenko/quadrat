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

-- interface
function piece:wrap()
  local opts  = {log=log.info}
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
  wrp.fn(piece, 'new',            {space, pid     })
  wrp.fn(piece, 'set_color',      {pid            }      )
  wrp.fn(piece, 'die',            {               }      )

  -- position
  --wrp.fn(piece, 'set_pos',        { {'to', type={name='vec', is=isvec}} }      )
  wrp.fn(piece, 'can_move',       {from,  to      })
  wrp.fn(piece, 'move_before',    {fspot, tspot   })
  wrp.fn(piece, 'move',           {fspot, tspot   })
  wrp.fn(piece, 'move_after',     {fspot, tspot   })
  
  -- jades
  wrp.fn(piece, 'add_jade',       {jade,          }      )
  wrp.fn(piece, 'remove_jade',    {id,    count   }      )
  wrp.fn(piece, 'use_jade',       {id             }      )

  -- powers
  wrp.fn(piece, 'add_power',      {power          }      )
  wrp.fn(piece, 'remove_power',   {id             }      )
  wrp.fn(piece, 'decrease_power', {name           }      )
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
  self.space:yell('set_color', self.pos, color) -- notify
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

-- POWER ----------------------------------------------------------------------
--
function piece:add_power(power)
  local count = self.powers:push(power)
  self.space:yell('add_power', self.pos, power.id, count) -- notify
end

--
function piece:decrease_power(id)
  self.powers:pull(id, 1)
  self.space:yell('add_power', self.pos, id, self.powers:count(id)) -- notify
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
  res = i:push({id='b', count=2, copy=copy})
  res = i:push({id='b', count=3, copy=copy})
  ass.eq(res, 5)

end

return piece