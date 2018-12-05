local types = require 'src.core.types'

local check = {}

-- check 'v' is a number
local function num(v)     return type(v) == 'number' end
-- check 'n' is natural number
local function nat(n)     return num(n) and (n >= 0) end
-- check 'v' is a table
local function tab(v)     return type(v) == 'table' end
-- check 'v' is a string
local function str(v)     return type(v) == 'string' end
-- check 'v' is a string
local function bool(v)    return type(v) == 'boolean' end
-- check 'v' is a function
local function fun(v)     return type(v) == 'function' end
-- check 'v' has meta T
local function is(v, t)   return getmetatable(v) == t
    --or (t == nil and v == nil)
    or (t == types.any and v ~= nil)
    or (t == types.tab and tab(v))
    or (t == types.num and num(v))
    or (t == types.str and str(v))
    or (t == types.fun and fun(v))
    or (t == types.ell and false)
    or (str(t) and tostring(getmetatable(v)) == t)
end

--
check.boolean = bool
check.fun = fun
check.natural = nat
check.number = num
check.string = str
check.table = tab
check.is = is

--
function check.test()
  print('check.test..')
  assert(check.natural(1))
  assert(check.number(2.7))
  assert(check.table({}))
  assert(check.string('hello'))
  assert(check.boolean(false))
  assert(check.fun(function() end))
end

return check