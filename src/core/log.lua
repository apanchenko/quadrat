local _   = require 'src.core.underscore'
local ass = require 'src.core.ass'

--
local Log = setmetatable({}, { __tostring = function() return 'Log' end })
Log.__index = Log

-- instance
local log = setmetatable({ depth = 0 }, Log)

--
function Log:__tostring() return 'log' end

-- increase stack depth
function Log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- chained to instantly call :enter()
function Log:trace(...)
  local str = string.rep('  ', self.depth)
  str = _.reduce(arg, str, function(mem, a) return mem.. tostring(a).. ' ' end)
  print(str)
  return self
end

-- decrease stack depth
function Log:exit(depth)
  assert(self.depth == depth)
  self.depth = depth - 1
end

-- wrap functions in table t with log
function Log:wrap(T, ...)
  ass.is(self, Log, ' in Log:wrap')
  ass.table(T, 'T')
  local names = {...} -- list of function names to wrap
  for i=1, #names do -- wrap each function
    -- function name
    local name = names[i]
    ass.string(name)
    -- original function
    local fun = T[name]
    ass.fun(fun)
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

function Log:test()
  print('test log..')
  ass.is(log, Log, 'log test')
end

log:test()

return log