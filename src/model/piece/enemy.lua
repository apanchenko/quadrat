local obj   = require('src.lua-cor.obj')

-- enemy piece interface for player
local enemy = obj:extend('piece_enemy')

-- private
local _piece = {}

--
function enemy:new(model_piece)
  self = obj.new(self)
  self[_piece] = model_piece
  return self
end

--
function enemy:is_friend()
  return false
end

-- is enemy piece jaded
function enemy:is_jaded()
  return not self[_piece].jades_cnt:is_empty()
end

--
function enemy:is_jump_protected()
  return self[_piece]:is_jump_protected()
end

-- wrap functions
function enemy:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('modl')
  local piece   = require('src.model.piece.piece')

  local is = {'piece_agent', typ.new_is(enemy)}
  local ex = {'piece_agent', typ.new_ex(enemy)}

  wrp.fn(log.trace, enemy, 'new',       is, {'piece', piece})
  wrp.fn(log.trace, enemy, 'is_friend', ex)
  wrp.fn(log.trace, enemy, 'is_jaded',  ex)
  wrp.fn(log.trace, enemy, 'is_jump_protected', ex)
end

return enemy