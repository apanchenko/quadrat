local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local obj     = require 'src.core.obj'
local wrp     = require 'src.core.wrp'
local typ     = require 'src.core.typ'

-- base non-additive power
local power = obj:extend('power')

-- constructor
-- @param piece - apply power to this piece
function power:new(piece, def)
  def.piece = piece
  return obj.new(self, def)
end

-- can spawn in jade
function power:can_spawn()
  return false
end

-- add to powers map, non-additive
function power:add_to(powers)
  powers[self.type] = self
  return 1
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

-- moves
function power:can_move   (from, to)  return false end
function power:move_before(cell_from, cell_to) end
function power:move       (cell_from, cell_to) end
function power:move_after (cell_from, cell_to) end

--jades
function power:on_add_jade(jade) end

-- module
function power.wrap()
  wrp.fn(power, 'new',      {{'Piece'}, {'def', typ.tab}})
  wrp.fn(power, 'add_to',   {{'powers', typ.tab}})
  wrp.fn(power, 'can_move', {{'from', 'vec'}, {'to', 'vec'}})
end

return power