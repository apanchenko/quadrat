local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local PowerMultiply = {}
PowerMultiply.__index = PowerMultiply

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMultiply.new(log, view)
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
  self.log:enter():trace(self, ":increase mult")
    self.count = self.count + 1
    self.text.text = tostring(self.count + 1)
  self.log:exit()
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
  print("PowerMultiply:move_after put to "..tostring(cell_from.pos))
  board:put(piece.color, cell_from.pos.x, cell_from.pos.y)
end

return PowerMultiply