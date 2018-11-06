local ass = require 'src.core.ass'

local Radial = 
{
  typename="Radial"
}
Radial.__index = Radial

-------------------------------------------------------------------------------
function Radial.new(pos)
  ass.Is(pos, "Vec")

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
  ass.Is(cell, "Cell")

  local distance = (cell.pos - self.pos):length2()
  return distance < 3
end

return Radial