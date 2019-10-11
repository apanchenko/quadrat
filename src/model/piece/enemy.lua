local obj = require('src.lua-cor.obj')

-- TODO rename file to foe

-- enemy piece interface for player
local piece_foe = obj:extend('piece_enemy')

-- private
local _piece = {}
local _space = {}

--
function piece_foe:new(piece_model, space_agent)
  self = obj.new(self)
  self[_piece] = piece_model
  self[_space] = space_agent
  return self
end

--
function piece_foe:get_space()
  return self[_space]
end

--
function piece_foe:get_pid()
  return self[_space]:get_my_pid()
end

--
function piece_foe:is_friend()
  return false
end

-- is enemy piece jaded
function piece_foe:is_jaded()
  return not self[_piece].jades_cnt:is_empty()
end

--
function piece_foe:is_jump_protected()
  return self[_piece]:is_jump_protected()
end

-- wrap functions
function piece_foe:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('mode')
  local piece_model = require('src.model.piece.piece')
  local space_agent = require('src.model.space.agent')

  local ex = typ.new_ex(piece_foe)

  wrp.fn(log.info, piece_foe, 'new',       piece_foe, piece_model, space_agent)
  wrp.fn(log.info, piece_foe, 'get_pid',   ex)
  wrp.fn(log.info, piece_foe, 'is_friend', ex)
  wrp.fn(log.info, piece_foe, 'is_jaded',  ex)
  wrp.fn(log.info, piece_foe, 'is_jump_protected', ex)
end

return piece_foe