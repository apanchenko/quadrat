local vec = require 'src.core.vec'
local lay = require 'src.core.lay'
local ass = require 'src.core.ass'
local cfg = require 'src.Config'
local log = require 'src.core.log'
local Class = require 'src.core.Class'

local Impeccable = Class.Create('Impeccable',
{
  is_areal = false,
  is_jump_protected = true,
  Stackable = false
})

--
function Impeccable.New(Zone)
  ass.nul(Zone)
  local self = setmetatable({}, Impeccable)
  return self
end

-- POWER ----------------------------------------------------------------------
--
function Impeccable:apply(piece)
  self._piece = piece
  return self
end
--
function Impeccable:increase()
  -- do nothing here
end
--
function Impeccable:decrease()
  return self
end
--
function Impeccable:count()
  return 1
end


-- MOVE------------------------------------------------------------------------
--
function Impeccable:can_move(from, to)
  return false
end
--
function Impeccable:move_before(cell_from, cell_to) end
function Impeccable:move(vec) end
function Impeccable:move_after(piece, board, cell_from, cell_to) end


-- MODULE ---------------------------------------------------------------------
ass.wrap(Impeccable, 'apply', 'Piece')

log:wrap(Impeccable, 'apply')

return Impeccable