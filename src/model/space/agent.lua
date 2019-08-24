local piece_enemy  = require('src.model.piece.enemy')
local piece_friend = require('src.model.piece.friend')
local space_board  = require('src.model.space.board')

-- space interface for agent
local space_agent = space_board:extend('space_agent')

-- private
local _space = {}
local _pid = {}

-- constructor
function space_agent:new(space_model, pid)
  self = space_board.new(self, space_model)
  self[_space] = space_model
  self[_pid] = pid
  return self
end

-- forward
function space_agent:listen(listener, name, subscribe)
  self[_space]:listen(listener, name, subscribe)
end

--
function space_agent:is_my_move()
  return self[_space]:get_move_pid() == self[_pid]
end

--
function space_agent:get_my_pid()
  return self[_pid]
end

--
function space_agent:get_piece(pos)
  local piece_model = self[_space]:piece(pos)
  if piece_model == nil then
    return nil
  end

  if piece_model:get_pid() == self[_pid] then
    return piece_friend:new(piece_model, self)
  else
    return piece_enemy:new(piece_model, self)
  end
end

--
function space_agent:can_move(from, to)
  return self[_space]:can_move(from, to)
end

--
function space_agent:move(from, to)
  self[_space]:move(from, to)
end

-- wrap functions
function space_agent:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('mode')
  local vec = require('src.lua-cor.vec')
  local playerid = require('src.model.playerid')
  local space   = require('src.model.space.space')

  local ex  = typ.new_ex(space_agent)

  wrp.fn(log.info, space_agent, 'new',           space_agent, space, playerid)
  wrp.fn(log.info, space_agent, 'get_piece',     ex, vec)
  wrp.fn(log.info, space_agent, 'can_move',      ex, vec, vec)
  wrp.fn(log.trace, space_agent, 'move',         ex, vec, vec)
  wrp.fn(log.trace, space_agent, 'listen',       ex, typ.tab, typ.str, typ.boo)
end

return space_agent