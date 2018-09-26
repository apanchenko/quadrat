local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Rehash = {}
Rehash.__index = Rehash

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Rehash.new(board, log, view)
  -- get board cells
  local grid = board:get_cells()

  -- empty cells to rehash
  local cells = {}

  -- count and remove jades, collect empty cells
  local count = 0
  for i, cell in ipairs(grid) do
    if cell.jade then
      count = count + 1
      cell:remove_jade()
    end
    if cell.piece == nil then
      cells[#cells + 1] = cell
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
function Rehash.name()
  return "Rehash"
end
-------------------------------------------------------------------------------
function Rehash:__tostring()
  return Rehash.name()
end
--[[
-------------------------------------------------------------------------------
function Rehash:increase()
end
-------------------------------------------------------------------------------
-- return self to persist or nil to cease
function Rehash:decrease()
  return nil
end

-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function Rehash:can_move(vec)
  return false
end
-------------------------------------------------------------------------------
function Rehash:move_before(cell_from, cell_to)
end
-------------------------------------------------------------------------------
function Rehash:move(vec)
end
-------------------------------------------------------------------------------
function Rehash:move_after(piece, board, cell_from, cell_to)
end
]]--
return Rehash