local vec = require 'src.core.Vec'
local lay = require 'src.core.lay'
local Ass = require 'src.core.Ass'
local cfg = require 'src.Config'
local log = require 'src.core.log'
local Type = require 'src.core.Type'

local Impeccable = Type.Create('Impeccable', { is_areal = false, is_jump_protected = true })
--
function Impeccable.new(Zone)
  Ass.Nil(Zone)
  local self = setmetatable({}, Impeccable)
  return self
end
--
function Impeccable:__tostring()
  return 'Impeccable'
end


-- POWER ----------------------------------------------------------------------
--
function Impeccable:apply(piece)
  self._piece = piece
  --self.img = lay.image(piece, cfg.cell, "src/battle/powers/impeccable.png")
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
Ass.Wrap(Impeccable, 'apply', 'Piece')

log:wrap(Impeccable, 'apply')

return Impeccable