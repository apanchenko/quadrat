local obj = require('src.lua-cor.obj')

--
local move = obj:extend('move')

-- private
local _fr = {}
local _to = {}

-- constructor
function move:new(from_vec, to_vec)
  self = obj.new(self)
  self[_fr] = from_vec
  self[_to] = to_vec
  return self
end

--
function move:get_from()
  return self[_fr]
end

--
function move:get_to()
  return self[_to]
end

-- wrap
function move:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local log = require('src.lua-cor.log')

  local ex = typ.new_ex(move)

  wrp.fn(log.info, move, 'new',        move)
  wrp.fn(log.info, move, 'get_from',   ex)
  wrp.fn(log.info, move, 'get_to',     ex)
end

return move