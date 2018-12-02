local Ass = require 'src.core.Ass'
local log = require 'src.core.log'
local check = require 'src.core.check'

local Class = {}

function Class.Create(name, t)
  t = t or {}

  Ass.String(name)
  Ass.Table(t, 'Class options is not a table: '..tostring(t))

  local T = setmetatable(t, { __tostring = function() return name end })
  T.__index = T

  return T
end

return Class