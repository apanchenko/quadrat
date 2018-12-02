local check = require 'src.core.check'

local Ass = setmetatable({}, {__call = function(cls, v, msg) return cls.True(v, msg) end})

-- 'v' is true
function Ass.True(v, msg)   return v or error(msg or tostring(v)..' is false') end
-- 'v' is nil
function Ass.Nil(v, msg)    return v == nil or error(msg or tostring(v)..' is not nil') end
-- 'v' is not nil
function Ass.NotNil(v, msg) return v ~= nil or error(msg or 'value is nil') end
-- 'v' is a number
function Ass.Number(v)      return check.Number(v) or error(tostring(v)..' is not a number') end
-- 'n' is natural number
function Ass.Natural(v)     return Ass.Number(v) and Ass(v >= 0) end
-- 'v' is a table
function Ass.Table(v, msg)  return check.Table(v) or error(msg or tostring(v)..' is not a table') end
-- 'v' is a string
function Ass.String(v)      return check.String(v) or error(tostring(v)..' is not a string') end
-- 'v' is a boolean
function Ass.Boolean(v)     return check.Boolean(v) or error(tostring(v)..' is not a boolean') end
-- 'v' is a function
function Ass.Fun(v, msg)    return check.Fun(v) or error(msg or tostring(v)..' is not a function') end
-- 'v' is an instance of T
function Ass.Is(t, T, msg)  return check.Is(t, T) or error(msg or tostring(t)..' is not '..tostring(T)) end

local IsStatic = function(name)
  local first = string.sub(name, 1, 1)
  return string.upper(first) == first
end

local Separators = {[true] = '.', [false] = ':'}

-- wrap function of T
-- ellipsis not supported
function Ass.Wrap(T, name, ...)
  Ass.Table(T, 'first arg is not a table in Ass.Wrap('..tostring(T)..', '..tostring(name)..')')
  Ass.String(name)
  local arg_types = {...}
  -- original function
  local fun = T[name]
  Ass.Fun(fun, tostring(T)..' has no function '..name)

  local is_static = IsStatic(name)
  local full_name = tostring(T)..Separators[is_static]..name

  local check_arguments = function(arg_types, ...)
    local args = {...}
    Ass(#args == #arg_types, full_name..' expected '..#arg_types..' args, found '..#args)
    for i=1, #args do
      Ass.Is(args[i], arg_types[i], 'expect '..tostring(arg_types[i])..' as '..i..' argument in '..full_name)
    end
  end

  -- define a new function
  if is_static then
    T[name] = function(...)
      check_arguments(arg_types, ...)
      return fun(...) -- call original function
    end
  else
    T[name] = function(s, ...)
      Ass.Is(s, T, full_name.." called via .") -- check self
      check_arguments(arg_types, ...)
      return fun(s, ...) -- call original function
    end    
  end
end

--
function Ass.Test()
  print('test Ass..')
  Ass(true)
  Ass.Nil(x)
  Ass.Number(8.8)
  Ass.Natural(9)
  Ass.Table({})
  Ass.String("String")
  Ass.Boolean(false)
  Ass.Fun(function() end)
end

return Ass