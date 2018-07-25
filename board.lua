local Cell = require("cell")
local Piece = require("piece")
local Pos = require("Pos")

Board = {}
Board.__index = Board
setmetatable(Board, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
function Board:__tostring()
  return "board "..tostring(self.size)
end

-------------------------------------------------------------------------------
function Board.new(width, height)
  local self = setmetatable({}, Board)
  self.size = Pos(width or 8, height or 8)

  local scale = display.contentWidth / (8 * Cell.size.x);
  self.scale = Pos(scale, scale)
  self.group = display.newGroup()
  self.group:scale(self.scale.x, self.scale.y)

  self.grid = {}
  for i = 0, self.size.x-1 do
    self.grid[i] = {}
    for j = 0, self.size.y-1 do
      local cell = Cell()
      cell:insert_into(self, i, j)
      self.grid[i][j] = cell
    end
  end

  return self
end

-------------------------------------------------------------------------------
function Board:position_default()
  for x = 0, self.size.x-1 do
    self:put(Piece(Piece.RED), Pos(x, 0))
    self:put(Piece(Piece.RED), Pos(x, 1))
    self:put(Piece(Piece.BLACK), Pos(x, self.size.y - 1))
    self:put(Piece(Piece.BLACK), Pos(x, self.size.y - 2))
  end
end

-------------------------------------------------------------------------------
function Board:put(piece, pos)
  print("Board:put "..tostring(piece).." at "..tostring(pos))
  assert(Pos(0, 0) <= pos and pos < self.size)
  self.grid[pos.x][pos.y].piece = piece
  piece:insert_into(self, pos)
end

-------------------------------------------------------------------------------
function Board:at(pos)
  return self.grid[pos.x][pos.y].piece
end

-------------------------------------------------------------------------------
function Board:can_move(fr, to)
  local piece = self:at(fr)
  if piece == nil then
    return false
  end
  if (self:at(to)) then
    return false
  end
  local distance = (piece.pos - to):length2()
  return distance == 1 or distance == 2
end

-------------------------------------------------------------------------------
function Board:move(fr, to)
  local piece = self:at(fr)
  assert(piece)

  self.grid[fr.x][fr.y].piece = nil
  self.grid[to.x][to.y].piece = piece

  piece:move(to)
end

return Board