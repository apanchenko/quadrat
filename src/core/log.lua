local arr = require 'src.core.arr'
local ass = require 'src.core.ass'

-- create log instance
local log = setmetatable({ depth = 0 }, { __tostring = function() return 'log' end })

-- increase stack depth
function log:enter()
  self.depth = self.depth + 1
  return self.depth
end

-- chained
function log:error(...)   return self:out('E ', ...) end
function log:warning(...) return self:out('W ', ...) end
function log:trace(...)   return self:out('T ', ...) end
function log:info(...)    return self:out('I ', ...) end

function log:out(prefix, ...)
  local str = prefix.. string.rep('  ', self.depth)
  str = arr.reduce(arg, str, function(mem, a) return mem.. tostring(a).. ' ' end)
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
  ass.eq(tostring(self), 'log', ' in Log:wrap')
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
      local depth = log:trace(tostring(self).. ':'.. name..'('.. arr.tostring(args, ', ').. ')'):enter()
      local result = fun(...)
      log:exit(depth)
      return result
    end
  end
end

-- @param arg_info - array of argument descriptions {name, tostring}, may be nil
-- @param args - array of arguments
-- @return string representation of arguments
local function arguments(arg_info, args)
  local merged = args
  if arg_info then
    ass.eq(#arg_info, #args)
    for i = 1, #args do
      local info = arg_info[i];
      local tostr = info.tostring or tostring
      merged[i] = info.name.. '='.. tostr(args[i])
    end
  end
  return arr.tostring(merged)
end

-- wrap function in t
-- @param opts is {name, static}
--    string  name - name for t
--    boolean static - is function static (called via .)
function log:wrap_fn(t, fn_name, arg_info, name, static)
  name = name or tostring(t)
  local call = 'log:wrap_fn('..name..', fn_name='..fn_name..')'

  ass.eq(self, log, 'self is not log in '.. call)
  ass.tab(t, 'first arg is not a table in '.. call)
  ass.str(fn_name, 'fn_name is not a string in'.. call)

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, 'no such function in '.. call)

  -- define a new function
  if static then
    t[fn_name] = function(...)
      local depth = log:trace(fn_name..'('..arguments(arg_info, arg)..')'):enter()
      local result = fn(...)
      log:exit(depth)
      return result
    end
  else
    t[fn_name] = function(...)
      local args = {...}
      table.remove(args, 1)
      local depth = log:trace(name..':'..fn_name..'('..arguments(arg_info, args)..')'):enter()
      local result = fn(...)
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