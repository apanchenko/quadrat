local ass     = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local typ     = require 'src.core.typ'
local counted = require 'src.model.power.counted'

local multiply = counted:extend('multiply')

-- constructor
function multiply:new(piece)
  self = counted.new(self, piece, 'multiply')
  self.count = 1
  return self
end

-- can spawn in jade
function multiply:can_spawn()
  return true
end

--
function multiply:__tostring()
  return tostring(multiply).. '['.. self.count.. ']'
end

-- implement pure virtual areal:apply_to_spot
-- change color of enemy pieces in zone
function multiply:move_after(from, to)
  local piece = self.piece
  from:spawn_piece(piece.pid)
  piece:decrease_power(self.id) -- decrease
end

--
function multiply.wrap()
  wrp.fn(multiply, 'new',         {{'Piece'}})
  wrp.fn(multiply, 'move_after',  {{'vec'}, {'vec'}})
end

-- selftest
function multiply.test()
end

return multiply