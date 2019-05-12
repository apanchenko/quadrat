local ass     = require 'src.luacor.ass'
local log     = require 'src.luacor.log'
local obj     = require 'src.luacor.obj'
local wrp     = require 'src.luacor.wrp'
local typ     = require 'src.luacor.typ'

-- base non-additive power
local power = obj:extend('power')

-- constructor
-- @param piece - apply power to this piece
function power:new(piece, def)
  def.piece = piece
  def.id = self:get_typename()
  return obj.new(self, def)
end

-- is it desired or undesired power
function power:is_positive()
  return true
end

-- can spawn in jade
function power:can_spawn()
  return false
end

-- add to powers map, non-additive
function power:add_to(powers)
  powers[self.id] = self
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
function power:wrap()
  wrp.wrap_tbl_trc(power, 'new',      {'piece'}, {'def', typ.tab})
  wrp.wrap_sub_trc(power, 'add_to',   {'powers', typ.tab})
  wrp.wrap_sub_trc(power, 'can_move', {'from', 'vec'}, {'to', 'vec'})
end

return power