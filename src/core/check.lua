local types = require 'src.core.types'

local check = setmetatable({}, {__tostring = function() return 'check' end})

-- check 'n' is natural number
function check.natural(n)   return check.number(n) and (n >= 0) end
-- check 'v' is a number
function check.number(v)    return type(v) == 'number' end
-- check 'v' is a table
function check.table(v)     return type(v) == 'table' end
-- check 'v' is a string
function check.string(v)    return type(v) == 'string' end
-- check 'v' is a string
function check.boolean(v)   return type(v) == 'boolean' end
-- check 'v' is a function
function check.fun(v)       return type(v) == 'function' end
-- check 'v' is of type 't'
function check.type(v, t)   return check.string(t) and type(v) == t end
  -- check 'v' has meta T
function check.is(v, t)
  return getmetatable(v) == t
    or (t == nil and v == nil)
    or (t == types.any and v ~= nil)
    or (t == types.tab and check.table(v))
    or (t == types.num and check.number(v))
    or (t == types.str and check.string(v))
    or (t == types.fun and check.fun(v))
    or (t == types.ell and false)
end

--
function check.test()
  print('test check..')
  assert(check.natural(1))
  assert(check.number(2.7))
  assert(check.table({}))
  assert(check.string('hello'))
  assert(check.boolean(false))
  assert(check.fun(function() end))
end

return check