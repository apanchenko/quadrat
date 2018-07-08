Cell = {}
Cell.__index = Cell
setmetatable(Cell, {__call = function(cls, ...) return cls.new(...) end})
function Cell:__tostring() return "cell" end

-------------------------------------------------------------------------------
-- public
Cell.width = 64
Cell.height = 64
Cell.sheet_opt = {width = Cell.width, height = Cell.height, numFrames = 2}
Cell.sheet = graphics.newImageSheet("cell_1_s.png", Cell.sheet_opt)

function Cell.new()
  local self = setmetatable({}, Cell)
  local frame = math.random(1, Cell.sheet_opt.numFrames);
  self.group = display.newGroup()
  self.img = display.newImageRect(self.group, Cell.sheet, frame, Cell.width, Cell.height)
  self.img.anchorX = 0
  self.img.anchorY = 0
  return self
end

return Cell