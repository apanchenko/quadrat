local obj = require('src.lua-cor.obj')

-- space interface for board
local space_board = obj:extend('space_board')

-- private
local _space = {}

-- constructor
function space_board:new(space_model)
  self = obj.new(self)
  self[_space] = space_model
  return self
end

--
function space_board:get_size()
  return self[_space].size
end

--
function space_board:has_jade(pos)
  return self[_space]:spot(pos):has_jade()
end

--
function space_board:add_listener(listener)
  self[_space].own_evt.add(listener)
end

--
function space_board:listen_set_move(listener, subscribe)
  self[_space]:listen_set_move(listener, subscribe)
end

--
function space_board:get_move_pid()
  return self[_space]:get_move_pid()
end

-- number of supporting pieces
function space_board:get_support_count(pos, pid)
  local space = self[_space]
  local support_count = 0
  pos:each_neighbour_in_grid(self:get_size(), function(neighbour_pos)
    local piece_model = space:piece(neighbour_pos)
    if piece_model and piece_model:get_pid() == pid and piece_model:can_move(neighbour_pos, pos) then
      support_count = support_count + 1
    end
  end)
  return support_count
end

-- wrap functions
function space_board:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local vec = require('src.lua-cor.vec')
  local log = require('src.lua-cor.log').get('mode')
  local space   = require('src.model.space.space')
  local playerid   = require('src.model.playerid')

  local is  = {'space_board', typ.new_is(space_board)}
  local ex  = {'space_board', typ.new_ex(space_board)}

  wrp.fn(log.info, space_board, 'new',           is, {'space', typ.meta(space)})
  wrp.fn(log.info, space_board, 'get_size',      ex)
  wrp.fn(log.info, space_board, 'has_jade',      ex, {'pos', vec})
  wrp.fn(log.trace, space_board, 'add_listener',  ex, {'listener', typ.tab})
  wrp.fn(log.trace, space_board, 'listen_set_move',  ex, {'listener', typ.tab}, {'subscribe', typ.boo})
  wrp.fn(log.info, space_board, 'get_move_pid',      ex)
  wrp.fn(log.info,  space_board, 'get_support_count', ex, {'pos', vec}, {'pid', playerid})
end

return space_board