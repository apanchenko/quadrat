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
  local str = string.rep('  ', self.depth)
  str = _.reduce(arg, str, function(mem, a) return mem.. tostring(a).. ' ' end)
  print(str)
  return self
end

-- decrease stack depth
function log:exit(depth)
  assert(self.depth == depth)
  self.depth = depth - 1
end

-- wrap functions in table t with log
function log:wrap(t, ...)
  ass.table(t)
  local names = {...} -- list of function names to wrap
  for i=1, #names do -- wrap each function
    -- function name
    local name = names[i]
    ass.string(name)
    -- original function
    local fun = t[name]
    ass.fun(fun)
    -- define a new function
    t[name] = function(...)
      local args = {...}
      local self = args[1]
      table.remove(args, 1)
      local depth = log:trace(self, ':'..name, unpack(args)):enter()
      fun(...)
      log:exit(depth)
    end
  end
end

return log