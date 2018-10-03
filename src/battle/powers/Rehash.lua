local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Rehash =
{
  typename = "Rehash",
  is_areal = false
}
Rehash.__index = Rehash

-------------------------------------------------------------------------------
function Rehash.new(Zone)
  assert(Zone == nil)
  local self = setmetatable({}, Rehash)
  return self
end
-------------------------------------------------------------------------------
function Rehash:apply(piece)
  -- get board cells
  local board = piece.board
  local grid = board:get_cells()

  -- empty cells to rehash
  local cells = board:select_cells(function(c) return c.piece == nil end)

  -- count and remove jades
  local count = 0
  for i = 1, #cells do
    if cells[i].jade then
      count = count + 1
      cells[i]:remove_jade()
    end
  end
  assert(count <= #cells)

  -- select 'count' rendom empty cells
  for i = 1, count do
    local j = math.random(#cells)
    cells[j]:set_jade()
    cells[j] = cells[#cells]
    cells[#cells] = nil
  end

  return nil
end
-------------------------------------------------------------------------------
function Rehash:__tostring()
  return Rehash.typename
end

return Rehash