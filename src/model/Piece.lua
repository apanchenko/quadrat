local ass   = require 'src.core.ass'
local Color = require 'src.model.Color'

local Piece = { typename = "Piece" }
Piece.__index = Piece

-- indexes
local COLOR = 1

-- create a piece
function Piece.new(color)
  Color.ass(color)

  local self = {}
  self[COLOR] = color
  return setmetatable(self, Piece)
end

function Piece:color()
  return self[COLOR]
end

-- true if model is valid
-- todo
function Piece:valid()
  if type(self) ~= 'table' then
    return false
  end
  return true
end

return Piece