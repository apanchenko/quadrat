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
function ass.number(value, name)
  ass.type(value, 'number', name)
end

-- check 'value' is a table
function ass.table(value, name)    ass.type(value, "table", name) end
-- check 'value' is a string
function ass.string(value, name)   ass.type(value, "string", name) end
-- check 'value' is a string
function ass.boolean(value, name)  ass.type(value, "boolean", name) end
-- check 'value' is a function
function ass.fun(value, name)      ass.type(value, "function", name) end

-- check 'value' is a basic type
function ass.type(value, typename, name)
  name = name or 'value'
  ass(value, name)
  assert(type(value) == typename, name.." is '"..type(value).."' ("..tostring(value).."), expected '"..typename.."'")
end

-- check value is a table with field 'typename'
function ass.is(t, T, message)
  if not check.Is(t, T) then
    error(tostring(t)..' is not '..tostring(T).. ': '.. tostring(message))
  end
end

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

return ass