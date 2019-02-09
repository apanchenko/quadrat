local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local obj     = require 'src.core.obj'
local wrp     = require 'src.core.wrp'
local typ     = require 'src.core.typ'

-- base power
local power = obj:extend('power')

-- constructor
-- @param piece - apply power to this piece
function power:new(piece, id)
  return obj.new(self,
  {
    piece = piece,
    id = id
  })
end

-- can spawn in jade
function power:can_spawn()
  return false
end

-- add to powers map
function power:add_to(powers)
  local other = powers[self.id]
  if other then
    other.count = other.count + self.count
    return other.count
  end

  powers[self.id] = self
  return self.count
end

-- use
function power:apply()
  return self
end
--
function power:increase()
end
--
function power:decrease()
end
--
function power:get_count()
  return 1
end
--
function power:can_move(from, to)
  return false
end
--
function power:move_before(cell_from, cell_to) end
function power:move(cell_from, cell_to) end
function power:move_after(cell_from, cell_to) end

-- module
function power.wrap()
  wrp.fn(power, 'new',      {{'Piece'}, {'id', typ.str}})
  wrp.fn(power, 'add_to',   {{'powers', typ.tab}})
  wrp.fn(power, 'can_move', {{'from', 'vec'}, {'to', 'vec'}})
  wrp.fn(power, 'apply',    {})
end

return power