local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"

local Col = {typename="Col"}
Col.__index = Col

-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Col.new(pos)
  assert(pos)

  local self = setmetatable({}, Col)
  self.pos = pos
  return self
end
-------------------------------------------------------------------------------
function Col:__tostring()
  return Col.typename
end
-------------------------------------------------------------------------------
function Col:filter(cell)
  return cell.pos.x == self.pos.x
end

return Col