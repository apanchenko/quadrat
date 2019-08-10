local invis = require('src.model.power.invisible')
local obj   = require('src.lua-cor.obj')

-- piece interface for player
local agent = obj:extend('piece_agent')

-- private
local _piece = {}
local _pid = {}

--
function agent:new(piece, player_id)
  self = obj.new(self)
  self[_piece] = piece
  self[_pid] = player_id
  return self
end

--
function agent:is_friend()
  return self[_piece]:get_pid() == self[_pid]
end

--
function agent:is_jump_protected()
  return self[_piece]:is_jump_protected()
end

--
function agent:is_invisible()
  if not self:is_friend() then
    return false
  end
  return self[_piece]:count_power(invis:get_typename())
end

-- wrap functions
function agent:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log').get('modl')
  local vec = require('src.lua-cor.vec')
  local playerid = require('src.model.playerid')
  local piece   = require('src.model.piece.piece')

  local is = {'piece_agent', typ.new_is(agent)}
  local ex = {'piece_agent', typ.new_ex(agent)}
  local pid = {'pid', typ.new_is(playerid)}
  local pos = {'pos', vec}

  wrp.fn(log.trace, agent, 'new',       is, {'piece', piece}, pid)
  wrp.fn(log.trace, agent, 'is_friend', ex)
  wrp.fn(log.trace, agent, 'is_jump_protected', ex, pos)
  wrp.fn(log.trace, agent, 'is_invisible', ex)
end

return agent