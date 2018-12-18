local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local obj     = require 'src.core.obj'

-- base power
local power = obj:extend('power')

-- constructor
-- @param piece - apply power to this piece
local obj_create = obj.create
function power:create(piece)
  return obj_create(self, {piece=piece})
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

function power:can_move(from, to)
  return false
end
--
function power:move_before(cell_from, cell_to) end
function power:move(cell_from, cell_to) end
function power:move_after(cell_from, cell_to) end

--
ass.wrap(power, ':create', 'Piece')
ass.wrap(power, ':apply')

log:wrap(power, 'create', 'apply')

return power