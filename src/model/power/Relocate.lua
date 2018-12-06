local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Relocate =
{
  typename = "Relocate",
  is_areal = false
}
Relocate.__index = Relocate

-------------------------------------------------------------------------------
function Relocate.new(Zone)
  assert(Zone == nil)
  local self = setmetatable({}, Relocate)
  return self
end
-------------------------------------------------------------------------------
function Relocate:apply(piece)
  local board = piece.board

  -- select all empty cells
  local cells = board:select_cells(function(c) return c.piece == nil end)

  -- choose random cell
  local target = cells[math.random(#cells)]

  board:move(piece:get_pos(), target.pos)
  return nil
end
-------------------------------------------------------------------------------
function Relocate:__tostring()
  return Relocate.typename
end

return Relocate