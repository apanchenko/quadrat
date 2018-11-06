local vec = require 'src.core.Vec'
local lay = require 'src.core.lay'
local ass = require 'src.core.ass'
local cfg = require 'src.Config'
local log = require 'src.core.log'

local Impeccable =
{
  typename = "Impeccable",
  is_areal = false,
  is_jump_protected = true
}
Impeccable.__index = Impeccable

-------------------------------------------------------------------------------
function Impeccable.new(Zone)
  ass.Nil(Zone)

  local self = setmetatable({}, Impeccable)
  return self
end
-------------------------------------------------------------------------------
function Impeccable:apply(piece)
  self.piece = piece
  self.img = lay.image(piece, cfg.cell, "src/battle/powers/impeccable.png")
  return self
end
-------------------------------------------------------------------------------
function Impeccable:__tostring()
  return Impeccable.typename
end
-------------------------------------------------------------------------------
function Impeccable:increase()
  -- do nothing here
end
-------------------------------------------------------------------------------
function Impeccable:decrease()
  return self
end

-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Impeccable:can_move(from, to)
  return false
end
-------------------------------------------------------------------------------
function Impeccable:move_before(cell_from, cell_to) end
function Impeccable:move(vec) end
function Impeccable:move_after(piece, board, cell_from, cell_to) end


return Impeccable