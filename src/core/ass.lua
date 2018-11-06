local check = require 'src.core.check'

local ass =
{
  typename = "ass"
}

-- check 'value' is not nil
function ass.not_nil(value, name)
  name = name or "value"
  assert(value ~= nil, name.. ' is nil')
end
setmetatable(ass, {__call = function(cls, ...) return cls.not_nil(...) end})

-- check 'value' is nil
function ass.nul(value, name)
  name = name or "value"
  assert(value == nil, name.. " is not nil")
end

-- check 'num' is natural number
function ass.natural(num, message)
  ass.number(num, message)
  ass(num >= 0, message)
end

-- check 'value' is a number
function ass.number(value, name)   ass.type(value, 'number', name) end

-- check 'value' is a table
function ass.table(v)   return check.Table(v) or error(tostring(v)..' is not a table') end
-- check 'value' is a string
function ass.string(v)  return check.String(v) or error(tostring(v)..' is not a string') end
-- check 'value' is a string
function ass.Boolean(v) return check.Boolean(v) or error(tostring(v)..' is not a boolean') end
-- check 'value' is a function
function ass.fun(v)     return check.Fun(v) or error(tostring(v)..' is not a function') end

-- check 'value' is a basic type
function ass.type(v, typename, name)
  name = name or 'v'
  ass(v, name)
  assert(type(v) == typename, name.." is '"..type(v).."' ("..tostring(v).."), expected '"..typename.."'")
end

-- check value is a table with field 'typename'
function ass.is(t, T) return check.Is(t, T) or error(tostring(t)..' is not '..tostring(T)) end

-- wrap functions in table t
function ass.Wrap(T, ...)
  ass.table(T)
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
      ass.is(args[1], T, "method '"..name.."' called with .")
      local result = fun(...)
      return result
    end
  end
end

function ass.Test()
  print('test ass..')
  ass.table({})
end

return ass