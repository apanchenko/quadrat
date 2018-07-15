local Piece = {}
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

Piece.RED = true
Piece.BLACK = false

-------------------------------------------------------------------------------
-- public
function Piece.new(color)
  local self = display.newGroup()
  self.color = color
  self.img = display.newImageRect(self, "piece_red.png", 64, 64)
  self.img.anchorX = 0
  self.img.anchorY = 0
  self.scale = 1

  function self:tostring()
    return "Piece "..(self.color==Piece.RED and "RED" or "BLACK")
  end

-- touch listener function
  function self:touch(event)
    if event.phase == "began" then
      display.getCurrentStage():setFocus(self, event.id)
      self.isFocus = true
      self.markX = self.x
      self.markY = self.y
      
    -- create project on board
      self.project_image = display.newImageRect(self.board.group, "piece_red_project.png", 64, 64)
      self.project_image.anchorX = 0
      self.project_image.anchorY = 0

    elseif self.isFocus then
      if event.phase == "moved" then
        self.board:project(self.project_image, event, self.markX, self.markY)
      elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus(self, nil)
        self.isFocus = false
      end
    end
    return true
  end
  self:addEventListener("touch", self)

  -- insert piece into group, with scale for dragging
  function self:insert_into(board)
    board.group:insert(self)
    self.board = board
  end

  return self
end

return Piece