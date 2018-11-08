local Ass = require 'src.core.Ass'

local Color = setmetatable({}, { __tostring = function() return 'Color' end })
Color.__index = Color
Color.R = setmetatable({}, Color)
Color.B = setmetatable({}, Color)

-- is_red ? R : B
function Color.red(is_red)
  Ass.Boolean(is_red)
  return is_red and Color.R or Color.B
end

-- is_red ? R : B
function Color.is_red(color)
  Ass.Is(color, Color)
  return color == Color.R
end

-- change color to another
function Color.swap(color)
  Ass.Is(color, Color)
  return color == Color.R and Color.B or Color.R
end

--
function Color:__tostring() 
  return self == Color.R and "red" or "black"
end

--
function Color.Test()
  print('test Color..')
  Ass(Color.R == Color.R)
  Ass(Color.B == Color.B)
  Ass(Color.R ~= Color.B)
  Ass(Color.red(true) == Color.R)
  Ass(Color.red(false) == Color.B)
  Ass(Color.is_red(Color.R))
  Ass(Color.swap(Color.R) == Color.B)
  Ass(tostring(Color.R) == 'red')
  Ass(tostring(Color.B) == 'black')
end

return Color