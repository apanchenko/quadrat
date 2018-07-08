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
    elseif self.isFocus then
      if event.phase == "moved" then
        self.x = event.x - event.xStart + self.markX
        self.y = event.y - event.yStart + self.markY
      elseif event.phase == "ended" or event.phase == "cancelled" then
        display.getCurrentStage():setFocus(self, nil)
        self.isFocus = false
      end
    end
    return true
  end
  self:addEventListener("touch", self)

  return self
end

return Piece