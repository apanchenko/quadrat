local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local object  = require 'src.core.object'

-- base power
local power = object:extend('power')
power.is_jump_protected = true

-- constructor
-- @param piece - apply power to this piece
local _create = object.create
function power:create(piece)
  return _create(self, {piece=piece})
end
-- use
function power:apply()
  return self
end
--
function power:increase()
  -- do nothing here
end
--
function power:decrease()
  return self
end
--
function power:count()
  return 1
end

function power:can_move(from, to)
  return false
end
--
function power:move_before(cell_from, cell_to) end
function power:move(vec) end
function power:move_after(piece, board, cell_from, cell_to) end

--
ass.wrap(power, ':create', 'Piece')
ass.wrap(power, ':apply')

log:wrap(power, 'create', 'apply')

return power