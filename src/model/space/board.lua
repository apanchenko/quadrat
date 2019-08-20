local obj = require('src.lua-cor.obj')

-- space interface for agent
local space_board = obj:extend('space_board')

-- private
local _space = {}

-- constructor
function space_board:new(space)
  self = obj.new(self)
  self[_space] = space
  return self
end

--
function space_board:get_size()
  return self[_space].size
end

--
function space_board:add_listener(listener)
  self[_space].own_evt.add(listener)
end

--
function space_board:listen_set_move(listener)
  self[_space]:listen_set_move(listener)
end
function space_board:unlisten_set_move(listener)
  self[_space]:unlisten_set_move(listener)
end

-- wrap functions
function space_board:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('mode')
  local space   = require('src.model.space.space')

  local is  = {'space_board', typ.new_is(space_board)}
  local ex  = {'space_board', typ.new_ex(space_board)}

  wrp.fn(log.info, space_board, 'new',           is, {'space', typ.meta(space)})
  wrp.fn(log.info, space_board, 'get_size',      ex)
  wrp.fn(log.trace, space_board, 'add_listener',  ex, {'listener', typ.tab})
  wrp.fn(log.trace, space_board, 'listen_set_move',  ex, {'listener', typ.tab})
end

return space_board