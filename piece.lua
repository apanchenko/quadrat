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

  setmetatable(self, {__tostring = function() return "Piece "..(self.color==Piece.RED and "RED" or "BLACK") end})

  return self
end

return Piece