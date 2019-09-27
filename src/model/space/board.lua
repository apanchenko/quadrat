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

-- EVENTS ----------------------------------------------------------------------
--
function space_board:listen_set_move      (listener, subscribe) self[_space]:listen(listener, 'set_move', subscribe) end
function space_board:listen_set_ability   (listener, subscribe) self[_space]:listen(listener, 'set_ability', subscribe) end
function space_board:listen_set_color     (listener, subscribe) self[_space]:listen(listener, 'set_color', subscribe) end
function space_board:listen_add_power     (listener, subscribe) self[_space]:listen(listener, 'add_power', subscribe) end
function space_board:listen_spawn_piece   (listener, subscribe) self[_space]:listen(listener, 'spawn_piece', subscribe) end
function space_board:listen_move_piece    (listener, subscribe) self[_space]:listen(listener, 'move_piece', subscribe) end
function space_board:listen_remove_piece  (listener, subscribe) self[_space]:listen(listener, 'remove_piece', subscribe) end
function space_board:listen_stash_piece   (listener, subscribe) self[_space]:listen(listener, 'stash_piece', subscribe) end
function space_board:listen_unstash_piece (listener, subscribe) self[_space]:listen(listener, 'unstash_piece', subscribe) end
function space_board:listen_spawn_jade    (listener, subscribe) self[_space]:listen(listener, 'spawn_jade', subscribe) end
function space_board:listen_remove_jade   (listener, subscribe) self[_space]:listen(listener, 'remove_jade', subscribe) end
function space_board:listen_modify_spot   (listener, subscribe) self[_space]:listen(listener, 'modify_spot', subscribe) end

-- wrap functions
function space_board:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local vec = require('src.lua-cor.vec')
  local log = require('src.lua-cor.log').get('mode')
  local space   = require('src.model.space.space')
  local playerid   = require('src.model.playerid')

  local ex  = typ.new_ex(space_board)

  wrp.fn(log.info,  space_board, 'new',                 space_board, space)
  wrp.fn(log.info,  space_board, 'get_size',            ex)
  wrp.fn(log.info,  space_board, 'has_jade',            ex, vec)
  wrp.fn(log.trace, space_board, 'listen_set_move',     ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_set_ability',  ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_set_color',    ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_add_power',    ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_spawn_piece',  ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_move_piece',   ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_remove_piece', ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_stash_piece',  ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_unstash_piece',ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_spawn_jade',   ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_remove_jade',  ex, typ.tab, typ.boo)
  wrp.fn(log.trace, space_board, 'listen_modify_spot',  ex, typ.tab, typ.boo)
  wrp.fn(log.info,  space_board, 'get_move_pid',        ex)
  wrp.fn(log.info,  space_board, 'get_support_count',   ex, vec, playerid)
end

return space_board