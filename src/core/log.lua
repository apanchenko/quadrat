local _   = require 'src.core.underscore'
local ass = require 'src.core.ass'

local Log =
{
  typename = "log"
}
Log.__index = Log

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
function Log:exit(check_depth)
  if check_depth ~= nil then
    assert(self.depth == check_depth)
  end

  self.depth = self.depth - 1
end

return Log