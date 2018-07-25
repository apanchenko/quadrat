local Pos = require("Pos")

-------------------------------------------------------------------------------
local Piece = {}
Piece.__index = Piece
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

Piece.RED = true
Piece.BLACK = false

-------------------------------------------------------------------------------
-- group - display group
-- color - bool, RED or BLACK
-- img   - image, piece view
-- scale - number
-- i, j  - int number, position on board
function Piece.new(color)
  local self = setmetatable({}, Piece)
  self.group = display.newGroup()
  self.color = color
  self.img = Piece.new_image(self.group, "piece_"..self:color_to_string()..".png")
  self.scale = 1
  self.group:addEventListener("touch", self)
  return self
end

-------------------------------------------------------------------------------
function Piece:die()
  self.group:removeSelf()
  self.group = nil
  self.img:removeSelf()
  self.img = nil
end

-------------------------------------------------------------------------------
function Piece.new_image(group, name)
  local img = display.newImageRect(group, name, 64, 64)
  img.anchorX = 0
  img.anchorY = 0
  return img
end

-------------------------------------------------------------------------------
function Piece:color_to_string()
  if self.color == Piece.BLACK then
    return "black"
  end
  return "red"
end

-------------------------------------------------------------------------------
function Piece:__tostring() 
  return "piece["..tostring(self.pos)..","..self:color_to_string().."]"
end

-------------------------------------------------------------------------------
-- touch listener function
function Piece:touch(event)
  if self.board.color ~= self.color then
    return true
  end
  
  if event.phase == "began" then
    display.getCurrentStage():setFocus(self.group, event.id)
    self.mark = Pos.from(self.group)
    self.project_image = Piece.new_image(self.board.group, "piece_"..self:color_to_string().."_project.png")
    Pos.copy(self.group, self.project_image)
    self.isFocus = true
  elseif self.isFocus then
    if event.phase == "moved" then
      local start = Pos(event.xStart, event.yStart)
      local proj = (((Pos.from(event) - start) / self.board.scale + self.mark) / Cell.size):round()
      if self.board:can_move(self.pos, proj) then
        self.proj = proj
        Pos.copy(proj * Cell.size, self.project_image)
      end
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.project_image:removeSelf()
      self.project_image = nil
      display.getCurrentStage():setFocus(self.group, nil)
      self.isFocus = false
      if self.proj then
        self.board:move(self.pos, self.proj)
        self.proj = nil
      end
    end
  end
  return true
end

-------------------------------------------------------------------------------
-- insert piece into group, with scale for dragging
function Piece:insert_into(board, pos)
  board.group:insert(self.group)
  self.board = board
  self:move(pos)
end

-------------------------------------------------------------------------------
function Piece:move(to)
  self.pos = to
  Pos.copy(to * Cell.size, self.group)
end

return Piece