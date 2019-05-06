local ass     = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local typ     = require 'src.core.typ'
local counted = require 'src.model.power.counted'

local multiply = counted:extend('Multiply')

-- can spawn in jade
function multiply:can_spawn()
  return true
end

--
function multiply:__tostring()
  return self.type.. '{'.. self.count.. '}'
end

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function multiply:move_after(from, to)
  local piece = self.piece
  from:spawn_piece(piece.pid)
  piece:decrease_power(self.type) -- decrease
end

--
function multiply:wrap()
  local fspot = {'fr', 'spot'}
  local tspot = {'to', 'spot'}

  wrp.wrap_sub_trc(multiply, 'move_after', fspot, tspot)
end

-- selftest
function multiply:test()
end

return multiply