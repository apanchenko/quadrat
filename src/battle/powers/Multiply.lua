local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Multiply =
{
  typename = "Multiply",
  is_areal = false
}
Multiply.__index = PowerMultiply

-------------------------------------------------------------------------------
function Multiply.new(Zone)
  assert(Zone == nil)
  local self = setmetatable({}, Multiply)
  self.count = 0
  return self
end
-------------------------------------------------------------------------------
function Multiply:apply(piece)
  assert(self.count == 0)
  self.log = piece.log
  self.count = 1
  self.text = lay.text(piece, {text=tostring(self.count + 1), fontSize=22})
  return self
end
-------------------------------------------------------------------------------
function Multiply:__tostring()
  return PowerMultiply.typename.. "[".. self.count.. "]"
end
-------------------------------------------------------------------------------
function Multiply:increase()
  local depth = self.log:trace(self, ":increase"):enter()
    self.count = self.count + 1
    self.text.text = tostring(self.count + 1)
  self.log:exit(depth)
end
-------------------------------------------------------------------------------
-- return self to persist or nil to cease
function Multiply:decrease()
  local depth = self.log:trace(self, ":decrease"):enter()
    local result = self
    if self.count <= 1 then
      result = nil
      self.text:removeSelf()
    else
      self.count = self.count - 1
      self.text.text = tostring(self.count + 1)
    end
  self.log:exit(depth)
  return result
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function Multiply:can_move(vec)
  return false
end
-------------------------------------------------------------------------------
function Multiply:move_before(cell_from, cell_to)
end
-------------------------------------------------------------------------------
function Multiply:move(vec)
end
-------------------------------------------------------------------------------
function Multiply:move_after(piece, board, cell_from, cell_to)
  local depth = self.log:trace(self, ":move_after from ", cell_from, " to ", cell_to):enter()
    board:put(piece.color, cell_from.pos.x, cell_from.pos.y)
    piece:remove_power(Multiply.typename)
  self.log:exit(depth)
end

return Multiply