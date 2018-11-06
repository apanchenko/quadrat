local check = require 'src.core.check'

-- check 'value' is not nil
local ass = setmetatable({},
{
  __call = function(cls, v, name) return v ~= nil or error((name or 'value')..' is nil') end
})

-- check 'num' is natural number
function ass.Natural(n) return ass.Number(n) and ass(n >= 0) end
-- 'v' is nil
function ass.Nil(v)     return v == nil or error(tostring(v)..' is not nil') end
-- 'v' is a number
function ass.Number(v)  return check.Number(v) or error(tostring(v)..' is not a number') end
-- 'v' is a table
function ass.Table(v)   return check.Table(v) or error(tostring(v)..' is not a table') end
-- 'v' is a string
function ass.String(v)  return check.String(v) or error(tostring(v)..' is not a string') end
-- 'v' is a boolean
function ass.Boolean(v) return check.Boolean(v) or error(tostring(v)..' is not a boolean') end
-- 'v' is a function
function ass.Fun(v)     return check.Fun(v) or error(tostring(v)..' is not a function') end
-- 'v' is an instance of T
function ass.Is(t, T)   return check.Is(t, T) or error(tostring(t)..' is not '..tostring(T)) end

-- wrap functions of T
function ass.Wrap(T, ...)
  ass.Table(T)
  local names = {...} -- list of function names to wrap
  for i=1, #names do -- wrap each function
    -- function name
    local name = names[i]
    ass.String(name)
    -- original function
    local fun = T[name]
    ass.Fun(fun)
    -- define a new function
    T[name] = function(...)
      local args = {...}
      ass.Is(args[1], T, "method '"..name.."' called with .")
      local result = fun(...)
      return result
    end
  end
end

function ass.Test()
  print('test ass..')
  ass.Table({})
end

return ass