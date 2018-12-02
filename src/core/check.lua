local Type = require 'src.core.Type'

local check = {}

-- check 'n' is natural number
function check.Natural(n)   return check.Number(n) and (n >= 0) end
-- check 'v' is a number
function check.Number(v)    return type(v) == 'number' end
-- check 'v' is a table
function check.Table(v)     return type(v) == 'table' end
-- check 'v' is a string
function check.String(v)    return type(v) == 'string' end
-- check 'v' is a string
function check.Boolean(v)   return type(v) == 'boolean' end
-- check 'v' is a function
function check.Fun(v)       return type(v) == 'function' end
-- check 'v' is of type 't'
function check.Type(v, t)   return check.String(t) and type(v) == t end
  -- check 'v' has meta T
function check.Is(v, T)
  return
       tostring(getmetatable(v)) == tostring(T)
    or (T == Type.Any and v ~= nil)
    or (T == Type.Nil and v == nil)
    or (T == Type.Tab and check.Table(v))
    or (T == Type.Num and check.Number(v))
    or (T == Type.Str and check.String(v))
    or (T == Type.Fun and check.Fun(v))
    or (T == Type.Ell and false)
end

--
function check.Test()
  print('test check..')
  assert(check.Natural(1))
  assert(check.Number(2.7))
  assert(check.Table({}))
  assert(check.String('hello'))
  assert(check.Boolean(false))
  assert(check.Fun(function() end))
end

return check