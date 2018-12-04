local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local types     = require 'src.core.types'
local cfg       = require 'src.Config'
local Color     = require 'src.model.Color'

-------------------------------------------------------------------------------
local Multiply = Class.Create('Multiply', {is_areal = false})
--
function Multiply.New()
  local self = setmetatable({}, Multiply)
  self.count = 0
  return self
end
--
function Multiply:__tostring()
  return tostring(Multiply).. "[".. self.count.. "]"
end

-- POWER ----------------------------------------------------------------------
--
function Multiply:apply(piece)
  assert(self.count == 0)
  self.count = 1
  --self.text = lay.text(piece, {text=tostring(self.count + 1), fontSize=22})
  return self
end
--
function Multiply:increase()
  self.count = self.count + 1
  --  self.text.text = tostring(self.count + 1)
end
-- return self to persist or nil to cease
function Multiply:decrease()
  local result = self
  if self.count <= 1 then
    result = nil
    --self.text:removeSelf()
  else
    self.count = self.count - 1
    --self.text.text = tostring(self.count + 1)
  end
  return result
end

-- POSITION--------------------------------------------------------------------
function Multiply:can_move(vec)
  return false
end
--
function Multiply:move_before(cell_from, cell_to)
end
--
function Multiply:move(vec)
end
--
function Multiply:move_after(piece, board, cell_from, cell_to)
  board:put(piece.color, cell_from.pos.x, cell_from.pos.y)
  piece:remove_power(Multiply.typename)
end

-- MODULE ---------------------------------------------------------------------
--Ass.Wrap(Multiply, 'New', Type.Nil)
Ass.Wrap(Multiply, 'apply', 'Piece')
Ass.Wrap(Multiply, 'increase')
Ass.Wrap(Multiply, 'decrease')

log:wrap(Multiply, 'apply', 'increase', 'decrease')

return Multiply