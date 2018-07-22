local Cell = require("Cell")
local Pos = require("Pos")

Board = {}
Board.__index = Board

-------------------------------------------------------------------------------
function Board:__tostring()
  return "Board "..self.width.."*"..self.height
end

-------------------------------------------------------------------------------
function Board.new(width, height)
  local self = setmetatable({}, Board)
  self.width = width or 8
  self.height = height or 8

  local scale = display.contentWidth / (8 * Cell.size.x);
  self.scale = Pos(scale, scale)
  self.group = display.newGroup()
  self.group:scale(self.scale.x, self.scale.y)

  self.grid = {}
  for i = 1, self.width do
    self.grid[i] = {}
    for j = 1, self.height do
      local cell = Cell()
      cell:insert_into(self, i-1, j-1)
      self.grid[i][j] = cell
    end
  end

  return self
end

-------------------------------------------------------------------------------
function Board:put(piece, pos)
  print("Board:put "..tostring(piece).." at "..tostring(pos))
  assert(pos.x >= 1 and pos.x <= self.width)
  assert(pos.y >= 1 and pos.y <= self.height)
  self.grid[pos.x][pos.y].piece = piece
  piece:insert_into(self, pos)
end

-------------------------------------------------------------------------------
function Board:can_move(piece, new_pos)
  local distance = (piece.pos - new_pos):length2()
  --print("can_move from "..tostring(piece.pos).." to "..tostring(new_pos).." "..distance)
  return distance == 1 or distance == 2
end

-------------------------------------------------------------------------------
function Board:move(fr, to)
  local piece = self.grid[fr.x][fr.y].piece
  assert(piece)

  self.grid[fr.x][fr.y].piece = nil
  self.grid[to.x][to.y].piece = piece

  piece:move(to)
end

return Board