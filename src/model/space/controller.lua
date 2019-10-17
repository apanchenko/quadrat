local asset        = require('src.model.piece.asset')
local space_board  = require('src.model.space.board')

-- space interface for agent
local Controller = space_board:extend('Controller')

-- private
local _space = {}
local _pid = {}

-- constructor
function Controller:new(space, pid)
  self = space_board.new(self, space)
  self[_space] = space
  self[_pid] = pid
  return self
end

-- forward
function Controller:listen(listener, name, subscribe)
  self[_space]:listen(listener, name, subscribe)
end

--
function Controller:is_my_move()
  return self[_space]:get_move_pid() == self[_pid]
end

--
function Controller:get_pid()
  return self[_pid]
end

--
function Controller:get_piece(pos)
  local piece_model = self[_space]:piece(pos)
  if piece_model == nil then
    return nil
  end

  return asset:new(piece_model, self)
end

--
function Controller:can_move(from, to)
  return self[_space]:can_move(from, to)
end

--
function Controller:move(from, to)
  self[_space]:move(from, to)
end

-- wrap functions
function Controller:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('mode')
  local vec = require('src.lua-cor.vec')
  local playerid = require('src.model.playerid')
  local space   = require('src.model.space.space')

  local ex  = typ.new_ex(Controller)

  wrp.fn(log.info, Controller, 'new',           Controller, space, playerid)
  wrp.fn(log.info, Controller, 'get_piece',     ex, vec)
  wrp.fn(log.info, Controller, 'can_move',      ex, vec, vec)
  wrp.fn(log.trace, Controller, 'move',         ex, vec, vec)
  wrp.fn(log.trace, Controller, 'listen',       ex, typ.tab, typ.str, typ.boo)
end

return Controller