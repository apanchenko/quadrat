local piece_enemy   = require('src.model.piece.enemy')
local invis         = require('src.model.power.invisible')

-- piece interface for player
local friend = piece_enemy:extend('piece_friend')

-- private
local _piece = {}

--
function friend:new(model_piece)
  self = piece_enemy.new(self, model_piece)
  self[_piece] = model_piece
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

-- wrap functions
function friend:wrap()
  local wrp     = require('src.lua-cor.wrp')
  local typ     = require('src.lua-cor.typ')
  local log     = require('src.lua-cor.log').get('modl')
  local piece   = require('src.model.piece.piece')

  local is = {'piece_agent', typ.new_is(friend)}
  local ex = {'piece_agent', typ.new_ex(friend)}

  wrp.fn(log.trace, friend, 'new',       is, {'piece', piece})
  wrp.fn(log.trace, friend, 'is_friend', ex)
  wrp.fn(log.trace, friend, 'get_jades', ex)
  wrp.fn(log.trace, friend, 'use_jade',  ex, {'id', typ.str})
  wrp.fn(log.trace, friend, 'is_invisible', ex)
end

return friend