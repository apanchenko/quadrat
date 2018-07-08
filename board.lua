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
  self.group = display.newGroup()
  self.grid = {}
  self.cell_w = 64
  self.cell_h = 64
  local cell_sheet_opt = {width = 64, height = 64, numFrames = 2}
  self.cell_sheet = graphics.newImageSheet("cell_1_s.png", cell_sheet_opt)
  
  for i = 1, self.width do
    self.grid[i] = {}
    for j = 1, self.height do
      local frame = math.random(1, cell_sheet_opt.numFrames);
      local cell = {}
      --cell.img = display.newImageRect(self.group, self.cell_sheet, frame, self.cell_w, self.cell_h)
      cell.img = display.newImageRect(self.group, "piece_red.png", 64, 64)
      cell.img.x = i * self.cell_w
      cell.img.y = j * self.cell_h
      self.grid[i][j] = cell
    end
  end

  local scale = display.contentWidth / (8 * 64)
  self.group:scale(scale, scale)
  return self
end

function Board:put(piece, i, j)
  print("Board:put "..tostring(piece).." at "..i..","..j)
  assert(i >= 1 and i <= self.width)
  assert(j >= 1 and j <= self.height)
  self.grid[i][j].piece = piece
  self.group:insert(piece.group)
  piece.group.x = i * self.cell_w
  piece.group.y = j * self.cell_h
end

return Board