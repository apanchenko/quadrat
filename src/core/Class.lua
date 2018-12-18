local ass = require 'src.core.ass'
local log = require 'src.core.log'
local chk = require 'src.core.chk'

local Class = {}

function Class.Create(name, t)
  t = t or {}

  ass.str(name)
  ass.table(t, 'Class options is not a table: '..tostring(t))

  local T = setmetatable(t, { __tostring = function() return name end })
  T.__index = T

  return T
end

return Class