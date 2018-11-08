local _   = require 'src.core.underscore'
local Ass = require 'src.core.Ass'

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
  Ass(tostring(self) == 'log', ' in Log:wrap')
  Ass.Table(T, 'T')
  local names = {...} -- list of function names to wrap
  for i=1, #names do -- wrap each function
    -- function name
    local name = names[i]
    Ass.String(name)
    -- original function
    local fun = T[name]
    Ass.Fun(fun)
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

function log.Test()
  print('test log..')
  Ass(tostring(log) == 'log', 'log test')
  Ass(log:enter() == 1)
  log:exit(1)
end

return log