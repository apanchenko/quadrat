local ass = {}

--[[-----------------------------------------------------------------------------
-----------------------------------------------------------------------------]]--
local function natural(num)
  assert(type(num) == "number")
  assert(num >= 0)
end
ass.natural = natural

return ass