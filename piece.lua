Piece = {}
Piece.__index = Piece
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

Piece.RED = true
Piece.BLACK = false

-------------------------------------------------------------------------------
-- public
function Piece.new(color)
  local self = setmetatable({}, Piece)
  self.group = display.newGroup()
  self.color = color
  self.img = display.newImageRect(self.group, "piece_red.png", 64, 64)
  
  return self
end

function Piece:__tostring() return "Piece "..(self.color==Piece.RED and "RED" or "BLACK") end

return Piece