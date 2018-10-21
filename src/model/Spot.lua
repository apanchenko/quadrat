local ass = require 'src.core.ass'

local Spot = {}

-- flags
local empty    = 0
local grave    = 1
local low      = 4
local normal   = 8
local high     = 16
local jade     = 32

-- create empty cell
function Spot.new()
  return empty
end

--
function Spot.is_jade(spot)
  ass.number(spot)
  return spot & jade
end

-- is valid
-- todo
function Spot.is_valid(cell)
  if type(cell) ~= 'number' then
    return false
  end
  return true
end

return Spot