local check = require 'src.core.check'

local m = {}

-- 'v' is true
function m.__call(_, v, msg) return v or error(msg or tostring(v)..' is false') end

local ass = setmetatable({}, m)

-- 'v' is nil
function ass.nul(v, msg)    return v == nil or error(msg or tostring(v)..' is not nil') end
-- 'v' is not nil
function ass.NotNil(v, msg) return v ~= nil or error(msg or 'value is nil') end
-- 'v' is a number
function ass.number(v)      return check.number(v) or error(tostring(v)..' is not a number') end
-- 'n' is natural number
function ass.natural(v)     return ass.number(v) and ass(v >= 0) end
-- 'v' is a table
function ass.table(v, msg)  return check.table(v) or error(msg or tostring(v)..' is not a table') end
-- 'v' is a string
function ass.str(v)         return check.string(v) or error(tostring(v)..' is not a string') end
-- 'v' is a boolean
function ass.bool(v)        return check.boolean(v) or error(tostring(v)..' is not a boolean') end
-- 'v' is a function
function ass.fun(v, msg)    return check.fun(v) or error(msg or tostring(v)..' is not a function') end
-- 'v' is an instance of T
function ass.is(t, T, msg)  return check.is(t, T) or error(msg or tostring(t)..' is not '..tostring(T)) end
--
function ass.eq(a, b, msg)  return a == b or error(msg or tostring(a).. ' ~= '.. tostring(b)) end
--
function ass.le(a, b, msg)  return a <= b or error(msg or tostring(a).. ' > '.. tostring(b)) end

-- wrap function of T
-- ellipsis not supported
function ass.wrap(t, name, ...)
  local tstr = tostring(tostring(t))
  ass.table(t, 'first arg is not a table in ass.wrap(?, '..tostring(name)..')')
  --ass.table(t, 'first arg is not a table in ass.wrap('..tstr..', '..tostring(name)..')')
  ass.str(name)

  local arg_types = {...}
  local sep = string.sub(name, 1, 1)
  local fname = string.sub(name, 2)
  local method = tstr..name
  local fun = t[fname]

  --print('ass.wrap ('..tstr..", '"..name.."'). Sep "..sep)
  ass(sep == '.' or sep == ':', 'ass.wrap('..tstr..", '"..name.."') use . or : before function name")
  ass.fun(fun, tostring(T)..' has no function '..name)

  local check_arguments = function(arg_types, ...)
    local args = {...}
    --print('  check args - expected '..#arg_types..', found '..#args)
    ass(#args == #arg_types, method..' expected '..#arg_types..' args, found '..#args)
    for i=1, #args do
      ass.is(args[i], arg_types[i], 'expect '..tostring(arg_types[i])..' as '..i..' argument in '..method.. ', found '..tostring(args[i]))
    end
  end

  -- define a new function
  if sep == '.' then
    t[fname] = function(...)
      --print('wrapped '..name)
      check_arguments(arg_types, ...)
      return fun(...) -- call original function
    end
  else
    t[fname] = function(s, ...)
      --print('call wrapped '..name..'('..tostring(s)..', ' ..tostring(({...})[1]) )
      --ass.is(s, t, name.." called via .") -- check self
      check_arguments(arg_types, ...)
      return fun(s, ...) -- call original function
    end    
  end
end

--
function ass.test()
  print('test ass..')
  ass(true)
  ass.nul(x)
  ass.number(8.8)
  ass.natural(9)
  ass.table({})
  ass.str("String")
  ass.bool(false)
  ass.fun(function() end)
end

return ass