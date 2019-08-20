local arr           = require('src.lua-cor.arr')
local piece_enemy   = require('src.model.piece.enemy')
local invis         = require('src.model.power.invisible')

-- piece interface for player
local piece_friend = piece_enemy:extend('piece_friend')

-- private
local _piece = {}
local _space = {}

--
function piece_friend:new(piece_model, space_agent)
  self = piece_enemy.new(self, piece_model, space_agent)
  self[_piece] = piece_model
  self[_space] = space_agent
  return self
end

--
function piece_friend:listen_set_move(listener)
  self[_space]:listen_set_move(listener)
end
function piece_friend:unlisten_set_move(listener)
  self[_space]:unlisten_set_move(listener)
end

-- override enemy:is_friend
function piece_friend:is_friend()
  return true
end

-- get all jade ids
function piece_friend:get_jades()
  return self[_piece].jades_cnt:keys()
end

-- use jade by id
function piece_friend:use_jade(id)
  self[_piece]:use_jade(id)
end

--
function piece_friend:is_invisible()
  if not self:is_friend() then
    return false
  end
  return self[_piece]:count_power(invis:get_typename())
end

-- MOVE ----------------------------------------------------------------------
--
function piece_friend:is_my_move()
  return self[_space]:is_my_move()
end

--
function piece_friend:can_move(to)
  return self[_space]:can_move(self[_piece]:get_pos(), to)
end

--
function piece_friend:move(to)
  self[_space]:move(self[_piece]:get_pos(), to)
end

-- return array of available move targets
function piece_friend:get_move_to_arr()
  local space = self[_space]
  local from = self[_piece]:get_pos()
  local to_arr = arr()
  space:get_size():iterate_grid(function(to)
    if space:can_move(from, to) then
      to_arr:push(to)
    end
  end)
  return to_arr
end

-- wrap functions
function piece_friend:wrap()
  local wrp     = require('src.lua-cor.wrp')
  local typ     = require('src.lua-cor.typ')
  local vec     = require('src.lua-cor.vec')
  local log     = require('src.lua-cor.log').get('mode')
  local piece_model = require('src.model.piece.piece')
  local space_agent = require('src.model.space.agent')

  local is = {'piece_agent', typ.new_is(piece_friend)}
  local ex = {'piece_agent', typ.new_ex(piece_friend)}

  wrp.fn(log.info, piece_friend, 'new',         is, {'piece', piece_model}, {'space_agent', space_agent})
  wrp.fn(log.info, piece_friend, 'is_friend',   ex)
  wrp.fn(log.info, piece_friend, 'get_jades',   ex)
  wrp.fn(log.trace, piece_friend, 'use_jade',   ex, {'id', typ.str})
  wrp.fn(log.info, piece_friend, 'is_invisible', ex)

  -- move
  wrp.fn(log.info, piece_friend, 'is_my_move',      ex)
  wrp.fn(log.info, piece_friend, 'can_move',        ex, {'to', vec})
  wrp.fn(log.info, piece_friend, 'move',            ex, {'to', vec})
  wrp.fn(log.info, piece_friend, 'get_move_to_arr', ex)
end

return piece_friend