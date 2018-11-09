local Ass = require 'src.core.Ass'
local log = require 'src.core.log'

local Type = {}

function Type.Create(name)
  Ass.String(name)

  local T = setmetatable({}, { __tostring = function() return name end })
  T.__index = T

  return T
end

return Type