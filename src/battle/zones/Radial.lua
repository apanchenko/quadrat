local ass = require 'src.core.ass'

local Radial = 
{
  typename="Radial"
}
Radial.__index = Radial

-------------------------------------------------------------------------------
function Radial.new(pos)
  ass.is(pos, "vec")

  local self = setmetatable({}, Radial)
  self.pos = pos
  return self
end
-------------------------------------------------------------------------------
function Radial:__tostring()
  return Radial.typename
end
-------------------------------------------------------------------------------
function Radial:filter(cell)
  ass.is(cell, "Cell")

  local distance = (cell.pos - self.pos):length2()
  return distance == 1 or distance == 2
end

return Radial