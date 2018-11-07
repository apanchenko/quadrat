local ass = require 'src.core.ass'

local Color = setmetatable({}, { __tostring = function() return 'Color' end })
Color.__index = Color
Color.R = setmetatable({}, Color)
Color.B = setmetatable({}, Color)

-- is_red ? R : B
function Color.red(is_red)
  ass.Boolean(is_red)
  return is_red and Color.R or Color.B
end

-- is_red ? R : B
function Color.is_red(color)
  ass.Is(color, Color)
  return color == Color.R
end

-- change color to another
function Color.swap(color)
  ass.Is(color, Color)
  return color == Color.R and Color.B or Color.R
end

--
function Color:__tostring() 
  return self == Color.R and "red" or "black"
end

--
function Color.Test()
  print('test Color..')
  ass(Color.R == Color.R)
  ass(Color.B == Color.B)
  ass(Color.R ~= Color.B)
  ass(Color.red(true) == Color.R)
  ass(Color.red(false) == Color.B)
  ass(Color.is_red(Color.R))
  ass(Color.swap(Color.R) == Color.B)
  ass(tostring(Color.R) == 'red')
  ass(tostring(Color.B) == 'black')
end

return Color