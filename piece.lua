local Pos = require("Pos")

-------------------------------------------------------------------------------
local Piece = {}

Piece.RED = true
Piece.BLACK = false

-------------------------------------------------------------------------------
-- self  - display group
-- color - bool, RED or BLACK
-- img   - image, piece view
-- scale - number
-- i, j  - int number, position on board
function Piece.new(color)
  local self = display.newGroup()
  self.color = color
  self.img = display.newImageRect(self, "piece_red.png", 64, 64)
  self.img.anchorX = 0
  self.img.anchorY = 0
  self.scale = 1
  self.pos = Pos.new()
  self:addEventListener("touch", self)

-------------------------------------------------------------------------------
  function self:tostring()
    return "piece["..tostring(self.pos)..","..(self.color==Piece.RED and "RED" or "BLACK").."]"
  end

-------------------------------------------------------------------------------
-- touch listener function
  function self:touch(event)
    if event.phase == "began" then
      self.board:project_begin(self, event, "piece_red_project.png", 64, 64)
      self.isFocus = true
    elseif self.isFocus then
      if event.phase == "moved" then
        self.board:project(self, event)
      elseif event.phase == "ended" or event.phase == "cancelled" then
        self.board:project_end(self)
        --self.project_image:removeSelf()
        --self.project_image = nil
        display.getCurrentStage():setFocus(self, nil)
        self.isFocus = false
      end
    end
    return true
  end

-------------------------------------------------------------------------------
-- insert piece into group, with scale for dragging
  function self:insert_into(board, pos)
    board.group:insert(self)
    self.board = board
    self.pos = pos
    self.x = pos.x * Cell.width
    self.y = pos.y * Cell.height    
  end

  --print(self:tostring())
  return self
end

return Piece