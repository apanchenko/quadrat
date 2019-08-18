local arr           = require('src.lua-cor.arr')
local piece_enemy   = require('src.model.piece.enemy')
local invis         = require('src.model.power.invisible')

-- piece interface for player
local friend = piece_enemy:extend('piece_friend')

-- private
local _piece = {}
local _space = {}

--
function friend:new(piece_model, space_agent)
  self = piece_enemy.new(self, piece_model, space_agent)
  self[_piece] = piece_model
  self[_space] = space_agent
  return self
end

-- override enemy:is_friend
function friend:is_friend()
  return true
end

-- get all jade ids
function friend:get_jades()
  return self[_piece].jades_cnt:keys()
end

-- use jade by id
function friend:use_jade(id)
  self[_piece]:use_jade(id)
end

--
function friend:is_invisible()
  if not self:is_friend() then
    return false
  end
  return self[_piece]:count_power(invis:get_typename())
end

-- return array of available move targets
function friend:get_move_to_arr()
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
function friend:wrap()
  local wrp     = require('src.lua-cor.wrp')
  local typ     = require('src.lua-cor.typ')
  local log     = require('src.lua-cor.log').get('mode')
  local piece_model = require('src.model.piece.piece')
  local space_agent = require('src.model.space.agent')

  local is = {'piece_agent', typ.new_is(friend)}
  local ex = {'piece_agent', typ.new_ex(friend)}

  wrp.fn(log.info, friend, 'new',       is, {'piece', piece_model}, {'space_agent', space_agent})
  wrp.fn(log.info, friend, 'is_friend', ex)
  wrp.fn(log.info, friend, 'get_jades', ex)
  wrp.fn(log.trace, friend, 'use_jade',  ex, {'id', typ.str})
  wrp.fn(log.info, friend, 'is_invisible', ex)
  wrp.fn(log.info, friend, 'get_move_to_arr', ex)
end

return friend