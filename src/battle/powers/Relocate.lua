local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Relocate = {}
Relocate.__index = Relocate

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Relocate.new(piece)
  local board = piece.board

  -- select all empty cells
  local cells = board:select_cells(function(c) return c.piece == nil end)

  -- choose random cell
  local target = cells[math.random(#cells)]

  board:move(piece.pos, target.pos)
  return nil
end
-------------------------------------------------------------------------------
function Relocate.name()
  return "Relocate"
end
-------------------------------------------------------------------------------
function Relocate:__tostring()
  return Relocate.name()
end

return Relocate