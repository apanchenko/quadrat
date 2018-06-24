Board = {}
Board.__index = Board
setmetatable(Board, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
-- private
local cell_w = display.contentWidth / 8
local cell_h = cell_w -- make cells square
local cell_sheet_opt = {width = 64, height = 64, numFrames = 2}
local cell_sheet = graphics.newImageSheet("battle/cell_1_s.png", cell_sheet_opt)

-------------------------------------------------------------------------------
-- public
function Board.new(width, height)
  local self = setmetatable({}, Board)
  self.width = width or 8
  self.height = height or 8
  self.display_group = display.newGroup()
  self.grid = {}

  for i = 1, self.width do
    self.grid[i] = {}
    for j = 1, self.height do
      local frame = math.random(1, cell_sheet_opt.numFrames);
      local cell = display.newImageRect(self.display_group, cell_sheet, frame, cell_w, cell_h)
      cell.x = i * cell_w - cell_w / 2
      cell.y = j * cell_h
      self.grid[i][j] = cell
    end
  end

  return self
end

function Board:__tostring()         return "Board "..self.width.."*"..self.height end

return Board