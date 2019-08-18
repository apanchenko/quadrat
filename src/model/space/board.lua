local obj = require('src.lua-cor.obj')

-- space interface for agent
local board = obj:extend('space_board')

-- private
local _space = {}

-- constructor
function board:new(space)
  self = obj.new(self)
  self[_space] = space
  return self
end

--
function board:get_size()
  return self[_space].size
end

--
function board:add_listener(listener)
  self[_space].own_evt.add(listener)
end

-- wrap functions
function board:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('mode')
  local space   = require('src.model.space.space')

  local is  = {'space_board', typ.new_is(board)}
  local ex  = {'space_board', typ.new_ex(board)}

  wrp.fn(log.info, board, 'new',           is, {'space', typ.meta(space)})
  wrp.fn(log.info, board, 'get_size',      ex)
  wrp.fn(log.trace, board, 'add_listener',  ex, {'listener', typ.tab})
end

return board