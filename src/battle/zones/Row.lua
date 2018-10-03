local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Row = {typename="Row"}
Row.__index = Row

-------------------------------------------------------------------------------
function Row.new(pos)
  local self = setmetatable({}, Row)
  self.pos = pos
  return self
end
-------------------------------------------------------------------------------
function Row:__tostring()
  return Row.typename
end
-------------------------------------------------------------------------------
function Row:filter(cell)
  return cell.pos.y == self.pos.y
end

return Row