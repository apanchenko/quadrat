local counted = require 'src.model.power.counted'
local log = require('src.lua-cor.log').get('mode')

local multiply = counted:extend('Multiply')

-- can spawn in jade
function multiply:can_spawn()
  return true
end

--
function multiply:__tostring()
  return self:get_typename().. '{'.. self.count.. '}'
end

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function multiply:move_after(from, to)
  local piece = self.piece
  from:spawn_piece(piece.pid)
  piece:decrease_power(self:get_typename()) -- decrease
end

--
function multiply:wrap()
  local wrp  = require('src.lua-cor.wrp')
  local typ  = require('src.lua-cor.typ')
  local spot = require('src.model.spot.spot')
  local ex   = typ.new_ex(multiply)

  wrp.fn(log.trace, multiply, 'move_after', ex, spot, spot)
end

return multiply