local ass = require 'src.core.ass'

local Color =
{
  R = true,
  B = false
}

-- assert is color
function Color.ass(color)
  ass.type(color, "boolean", "color")
end

-- change color to another
function Color.swap(color)
  Color.ass(color)
  return not color
end

--
function Color.string(color)
  Color.ass(color)
  if color == Color.R then
    return "red"
  end
  return "black"
end
  

return Color