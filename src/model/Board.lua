local Cell      = require 'src.model.Cell'
local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local Vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'

local Board = { typename = "Board" }
Board.__index = Board

-------------------------------------------------------------------------------
-- create Board model ready to play
function Board.new(cols, rows)
  ass.natural(cols)
  ass.natural(rows)

  -- create empty grid
  local grid = {}
  local pics = {}
  for x = 0, cols - 1 do
  for y = 0, rows - 1 do
    place = x * cols + y
    grid[place] = Cell.create()
    if y == 0 or y == rows-1 then
      pics[place] = Piece.new(Color.red(y == 0))
    end
  end
  end

  local self =
  {
    cols  = cols,    -- width
    rows  = rows,    -- height
    grid  = grid,    -- cells
    pics  = pics,    -- pieces
    color = Color.red(true), -- who moves now
  }  
  return setmetatable(self, Board)
end

--
function Board:width()      return self.cols end
--
function Board:height()     return self.rows end
--
function Board:cells()      return pairs(self.grid) end
--
function Board:pieces()     return pairs(self.pics) end
--
function Board:pos(place)   return Vec(self:col(place), self:row(place)) end
--
function Board:row(place)   return place % self.cols end
-- place // self.cols
function Board:col(place)   return (place - (place % self.cols)) / self.cols end

-- get color to move
function Board:who_move()
  return self.color
end

-- is color moves
function Board:is_move(color)
  Color.ass(color)
  return self.color == color
end

-- do move
function Board:move()
  self.color = Color.swap(self.color)
end

-- true if valid
function Board:valid()
  return true
end

-- return module
return Board