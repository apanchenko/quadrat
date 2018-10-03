local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local PowerMultiply =
{
  typename = "Multiply",
  is_areal = false
}
PowerMultiply.__index = PowerMultiply

-------------------------------------------------------------------------------
function PowerMultiply.new(Zone)
  assert(Zone == nil)
  local self = setmetatable({}, PowerMultiply)
  self.count = 0
  return self
end
-------------------------------------------------------------------------------
function PowerMultiply:apply(piece)
  assert(self.count == 0)
  self.log = piece.log
  self.count = 1
  self.text = lay.text(piece, {text=tostring(self.count + 1), fontSize=22})
  return self
end
-------------------------------------------------------------------------------
function PowerMultiply:__tostring()
  return PowerMultiply.typename.. "[".. self.count.. "]"
end
-------------------------------------------------------------------------------
function PowerMultiply:increase()
  self.log:trace(self, ":increase"):enter()
    self.count = self.count + 1
    self.text.text = tostring(self.count + 1)
  self.log:exit()
end
-------------------------------------------------------------------------------
-- return self to persist or nil to cease
function PowerMultiply:decrease()
  self.log:trace(self, ":decrease"):enter()
    local result = self
    if self.count <= 1 then
      result = nil
      self.text:removeSelf()
    else
      self.count = self.count - 1
      self.text.text = tostring(self.count + 1)
    end
  self.log:exit()
  return result
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMultiply:can_move(vec)
  return false
end
-------------------------------------------------------------------------------
function PowerMultiply:move_before(cell_from, cell_to)
end
-------------------------------------------------------------------------------
function PowerMultiply:move(vec)
end
-------------------------------------------------------------------------------
function PowerMultiply:move_after(piece, board, cell_from, cell_to)
  self.log:trace(self, ":move_after from ", cell_from, " to ", cell_to):enter()
    board:put(piece.color, cell_from.pos.x, cell_from.pos.y)
    piece:remove_power(self:name())
  self.log:exit()
end

return PowerMultiply