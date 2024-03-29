local log     = require('src.lua-cor.log').get('mode')
local obj     = require('src.lua-cor.obj')

-- base non-additive power
local power = obj:extend('power')

-- constructor
-- @param piece - apply power to this piece
function power:new(piece, world, def)
  def.piece = piece
  def.world = world
  def.id = self:get_typename()
  self = obj.new(self, def)
  return self
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
  local wrp     = require('src.lua-cor.wrp')
  local typ     = require('src.lua-cor.typ')
  local vec     = require('src.lua-cor.vec')
  local piece   = require('src.model.piece.piece')
  local World = require('src.model.space.space')

  local ex    = typ.new_ex(power)
  wrp.fn(log.trace, power, 'new',      power, piece, typ.ext(World), typ.tab)
  wrp.fn(log.trace, power, 'add_to',   ex, typ.tab)
  wrp.fn(log.info, power, 'can_move', ex, vec, vec)
end

return power