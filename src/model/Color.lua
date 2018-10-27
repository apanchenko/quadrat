local ass = require 'src.core.ass'

local R = 1
local B = 2

local Color =
{
  R = R,
  B = B
}

-- assert is color
function Color.ass(color)
  ass.number(color, "color")
  ass(color == R or color == B, "color")
end

-- is_red ? R : B
function Color.red(is_red)
  ass.boolean(is_red)
  return is_red and R or B
end

-- is_red ? R : B
function Color.is_red(color)
  Color.ass(color)
  return color == R
end

-- change color to another
function Color.swap(color)
  Color.ass(color)
  return color == R and B or R
end

--
function Color.string(color)
  Color.ass(color)
  return color == R and "red" or "black"
end
  

return Color