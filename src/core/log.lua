local _   = require 'src.core.underscore'
local ass = require 'src.core.ass'

-- create log instance
local log = setmetatable({ depth = 0 }, { __tostring = function() return 'log' end })

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
function log:wrap(T, ...)
  ass(tostring(self) == 'log', ' in Log:wrap')
  ass.table(T, 'first arg is not a table in log.wrap('..tostring(T)..')')
  local names = {...} -- list of function names to wrap
  for i=1, #names do -- wrap each function
    -- function name
    local name = names[i]
    ass.str(name, 'log:wrap - '..i..' function name is not a string')
    -- original function
    local fun = T[name]
    ass.fun(fun, 'log:wrap - no function '..tostring(T)..':'..name)
    -- define a new function
    T[name] = function(...)
      local args = {...}
      local self = table.remove(args, 1)
      local depth = log:trace(self, ':'..name, unpack(args)):enter()
      local result = fun(...)
      log:exit(depth)
      return result
    end
  end
end

function log.test()
  print('test log..')
  ass(tostring(log) == 'log', 'log test')
  ass(log:enter() == 1)
  log:exit(1)
end

return log