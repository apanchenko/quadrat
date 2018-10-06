local _   = require 'src.core.underscore'
local ass = require 'src.core.ass'

local Log =
{
  typename = "log"
}
Log.__index = Log

-- create new Log object
function Log.new()
  local self = setmetatable({}, Log)
  self.depth = 0
  return self
end

-- increase stack depth
function Log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- chained to instantly call :enter()
function Log:trace(...)
  local str = string.rep("  ", self.depth)
  str = _.reduce(arg, str, function(mem, a) return mem.. tostring(a) end)
  print(str)
  return self
end

-- decrease stack depth
function Log:exit(depth)
  assert(self.depth == depth)
  self.depth = depth - 1
end

return Log