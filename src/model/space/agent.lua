local piece_agent = require('src.model.piece.agent')
local obj         = require('src.lua-cor.obj')

-- space interface for agent
local agent = obj:extend('space_agent')

-- private
local _space = {}
local _pid = {}

-- constructor
function agent:new(space, pid)
  self = obj.new(self)
  self[_space] = space
  self[_pid] = pid
  return self
end

--
function agent:is_my_move()
  return self[_space]:who_move() == self[_pid]
end

--
function agent:get_my_pid()
  return self[_pid]
end

--
function agent:get_size()
  return self[_space].size
end

--
function agent:has_jade(pos)
  return self[_space]:spot(pos):has_jade()
end

--
function agent:get_piece(pos)
  local piece = self[_space]:piece(pos)
  if piece == nil then
    return nil
  end
  return piece_agent:new(piece, self[_pid])
end

--
function agent:can_move(from, to)
  return self[_space]:can_move(from, to)
end

--
function agent:move(from, to)
  self[_space]:move(from, to)
end

--
function agent:add_listener(listener)
  self[_space].own_evt.add(listener)
end

-- wrap functions
function agent:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('modl')
  local vec = require('src.lua-cor.vec')
  local playerid = require('src.model.playerid')
  local space   = require('src.model.space.space')

  local is = {'space_agent', typ.new_is(agent)}
  local ex = {'space_agent', typ.new_ex(agent)}
  local pid = {'pid', typ.new_is(playerid)}
  local pos = {'pos', typ.new_is(vec)}

  wrp.fn(log.trace, agent, 'new',       is, {'space', typ.meta(space)}, pid)
  wrp.fn(log.trace, agent, 'get_size', ex)
  wrp.fn(log.trace, agent, 'has_jade', ex, pos)
  wrp.fn(log.trace, agent, 'get_piece', ex, pos)
  wrp.fn(log.trace, agent, 'can_move',     ex,  {'from', vec}, {'to', vec})
  wrp.fn(log.trace, agent, 'move',         ex,  {'from', vec}, {'to', vec})
  wrp.fn(log.trace, agent, 'add_listener', ex, {'listener', typ.tab})
end

return agent