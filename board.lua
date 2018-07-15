local Cell = require("cell")

Board = {}
Board.__index = Board
setmetatable(Board, {__call = function(cls, ...) return cls.new(...) end})
function Board:__tostring() return "Board "..self.width.."*"..self.height end

-------------------------------------------------------------------------------
-- public
function Board.new(width, height)
  local self = setmetatable({}, Board)
  self.width = width or 8
  self.height = height or 8
  self.scale = display.contentWidth / (8 * Cell.width)
  self.group = display.newGroup()
  self.group:scale(self.scale, self.scale)

  self.grid = {}
  for i = 1, self.width do
    self.grid[i] = {}
    for j = 1, self.height do
      local cell = Cell()
      cell:insert(self.group, i-1, j-1)
      self.grid[i][j] = cell
    end
  end

  return self
end

function Board:put(piece, i, j)
  print("Board:put "..piece:tostring().." at "..i..","..j)
  assert(i >= 1 and i <= self.width)
  assert(j >= 1 and j <= self.height)
  self.grid[i][j].piece = piece
  --self.group:insert(piece)
  piece:insert_into(self)
end

return Board