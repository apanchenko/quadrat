local _   = require 'src.core.underscore'
local ass = require 'src.core.ass'

local log =
{
  typename = "log",
  depth = 0
}

-- increase stack depth
function log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- chained to instantly call :enter()
function log:trace(...)
  local str = string.rep("  ", self.depth)
  str = _.reduce(arg, str, function(mem, a) return mem.. tostring(a) end)
  print(str)
  return self
end

-- decrease stack depth
function log:exit(depth)
  assert(self.depth == depth)
  self.depth = depth - 1
end

return log