local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local PowerMultiply = {}
PowerMultiply.__index = PowerMultiply

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMultiply.new(board, log, view)
  local self = setmetatable({log = log}, PowerMultiply)
  self.count = 1
  self.text = lay.text(view, {text=tostring(self.count + 1), fontSize=22})
  self.log:trace(self, ".new")
  return self
end
-------------------------------------------------------------------------------
function PowerMultiply.name()
  return "Multiply"
end
-------------------------------------------------------------------------------
function PowerMultiply:__tostring()
  return PowerMultiply.name() .. "[" .. self.count .. "]"
end

-------------------------------------------------------------------------------
function PowerMultiply:increase()
  self.log:enter():trace(self, ":increase")
    self.count = self.count + 1
    self.text.text = tostring(self.count + 1)
  self.log:exit()
end
-------------------------------------------------------------------------------
-- return self to persist or nil to cease
function PowerMultiply:decrease()
  self.log:enter():trace(self, ":decrease")
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
  self.log:enter():trace(self, ":move_after from ", cell_from, " to ", cell_from)
    board:put(piece.color, cell_from.pos.x, cell_from.pos.y)
    piece:remove_power(self:name())
  self.log:exit()
end

return PowerMultiply