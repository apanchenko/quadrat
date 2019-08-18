local piece_enemy  = require('src.model.piece.enemy')
local piece_friend = require('src.model.piece.friend')
local space_board  = require('src.model.space.board')

-- space interface for agent
local agent = space_board:extend('space_agent')

-- private
local _space = {}
local _pid = {}

-- constructor
function agent:new(space, pid)
  self = space_board.new(self, space)
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
function agent:has_jade(pos)
  return self[_space]:spot(pos):has_jade()
end

--
function agent:get_piece(pos)
  local model_piece = self[_space]:piece(pos)
  if model_piece == nil then
    return nil
  end

  if model_piece:get_pid() == self[_pid] then
    return piece_friend:new(model_piece)
  else
    return piece_enemy:new(model_piece)
  end
end

--
function agent:can_move(from, to)
  return self[_space]:can_move(from, to)
end

--
function agent:move(from, to)
  self[_space]:move(from, to)
end

-- wrap functions
function agent:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('modl')
  local vec = require('src.lua-cor.vec')
  local playerid = require('src.model.playerid')
  local space   = require('src.model.space.space')

  local is  = {'space_agent', typ.new_is(agent)}
  local ex  = {'space_agent', typ.new_ex(agent)}
  local pid = {'pid', typ.new_is(playerid)}
  local pos = {'pos', typ.new_is(vec)}

  wrp.fn(log.trace, agent, 'new',           is, {'space', typ.meta(space)}, pid)
  wrp.fn(log.trace, agent, 'has_jade',      ex, pos)
  wrp.fn(log.trace, agent, 'get_piece',     ex, pos)
  wrp.fn(log.trace, agent, 'can_move',      ex, {'from', vec}, {'to', vec})
  wrp.fn(log.trace, agent, 'move',          ex, {'from', vec}, {'to', vec})
end

return agent