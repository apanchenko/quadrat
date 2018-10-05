local ass = require 'src.core.ass'

local Color =
{
  R = true,
  B = false
}

function Color.ass(color)
  ass.type(color, "boolean", "color")
end

return Color