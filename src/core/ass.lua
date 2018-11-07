local check = require 'src.core.check'

local ass = setmetatable({}, {__call = function(cls, v, msg) return cls.True(v, msg) end})

-- 'v' is true
function ass.True(v, msg) return v or error(msg or tostring(v)..' is false') end
-- 'v' is nil
function ass.Nil(v, msg) return v == nil or error(msg or tostring(v)..' is not nil') end
-- 'v' is not nil
function ass.NotNil(v, msg) return v ~= nil or error(msg or 'value is nil') end
-- 'v' is a number
function ass.Number(v) return check.Number(v) or error(tostring(v)..' is not a number') end
-- 'n' is natural number
function ass.Natural(v) return ass.Number(v) and ass(v >= 0) end
-- 'v' is a table
function ass.Table(v) return check.Table(v) or error(tostring(v)..' is not a table') end
-- 'v' is a string
function ass.String(v) return check.String(v) or error(tostring(v)..' is not a string') end
-- 'v' is a boolean
function ass.Boolean(v) return check.Boolean(v) or error(tostring(v)..' is not a boolean') end
-- 'v' is a function
function ass.Fun(v) return check.Fun(v) or error(tostring(v)..' is not a function') end
-- 'v' is an instance of T
function ass.Is(t, T, msg) return check.Is(t, T) or error(msg or tostring(t)..' is not '..tostring(T)) end

-- wrap function of T
function ass.Wrap(T, name, ...)
  ass.Table(T)
  ass.String(name)
  local arg_types = {...}
  -- original function
  local fun = T[name]
  ass.Fun(fun)
  -- define a new function
  T[name] = function(s, ...)
    -- check self
    ass.Is(s, T, tostring(T)..":"..name.." called with .")
    -- check arguments
    local args = {...}
    local full_name = tostring(T)..':'..name
    ass(#args == #arg_types, 'wrong number of arguments in '..full_name)
    for i=1, #args do 
      ass.Is(args[i], arg_types[i], 'expect '..tostring(arg_types[i])..' as '..i..' argument in '..full_name)
    end
    -- call original function
    return fun(s, ...)
  end
end

--
function ass.Test()
  print('test ass..')
  ass(true)
  ass.Nil(x)
  ass.Number(8.8)
  ass.Natural(9)
  ass.Table({})
  ass.String("String")
  ass.Boolean(false)
  ass.Fun(function() end)
end

return ass