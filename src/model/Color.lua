local ass = require 'src.core.ass'

local R = 1
local B = 2

local Color = {}

-- assert is color
function Color.ass(color)
  ass.type(color, "number", "color")
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
  if color == R then
    return "red"
  end
  return "black"
end
  

return Color