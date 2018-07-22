local Cell = require("cell")
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
  self.scale = display.contentWidth / (8 * Cell.width)
  self.group = display.newGroup()
  self.group:scale(self.scale, self.scale)

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
  print("Board:put "..piece:tostring().." at "..tostring(pos))
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
function Board:project_begin(piece, event, image_name, rect_size)
  display.getCurrentStage():setFocus(piece, event.id)
  piece.markX = piece.x
  piece.markY = piece.y
  piece.project_image = display.newImageRect(self.group, image_name, rect_size, rect_size)
  piece.project_image.anchorX = 0
  piece.project_image.anchorY = 0
end

-------------------------------------------------------------------------------
function Board:project(piece, event)
  local i = ((event.x - event.xStart) / self.scale + piece.markX) / Cell.width
  local j = ((event.y - event.yStart) / self.scale + piece.markY) / Cell.height
  if self:can_move(piece, Pos.new(i, j):round()) then
    piece.project_image.x = math.round(i) * Cell.width
    piece.project_image.y = math.round(j) * Cell.height
  end
end

-------------------------------------------------------------------------------
function Board:project_end(piece)
  piece.project_image:removeSelf()
  piece.project_image = nil
end

return Board