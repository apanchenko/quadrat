local typ = require 'src.core.typ'

-- check 'v' is a number
local function num(v)     return type(v) == 'number' end
-- check 'n' is natural number
local function nat(n)     return num(n) and (n >= 0) end
-- check 'v' is a table
local function tab(v)     return type(v) == 'table' end
-- check 'v' is a string
local function str(v)     return type(v) == 'string' end
-- check 'v' is a string
local function boo(v)     return type(v) == 'boolean' end
-- check 'v' is a function
local function fun(v)     return type(v) == 'function' end
-- check 'v' has meta T
local function is(v, t)   return getmetatable(v) == t
    --or (t == nil and v == nil)
    or (t == typ.any and v ~= nil)
    or (t == typ.tab and tab(v))
    or (t == typ.num and num(v))
    or (t == typ.str and str(v))
    or (t == typ.fun and fun(v))
    or (t == typ.ell and false)
    or (str(t) and tostring(getmetatable(v)) == t)
    or (v == t)
end

local chk =
{
  num = num,
  nat = nat,
  tab = tab,
  str = str,
  boo = boo,
  fun = fun,
  is = is
}

--
function chk.test()
  print('check.test..')
  assert(chk.nat(1))
  assert(chk.num(2.7))
  assert(chk.tab({}))
  assert(chk.str('hello'))
  assert(chk.boo(false))
  assert(chk.fun(function() end))
  assert(chk.is(1, 1))
  assert(not chk.is({}, {}))
end

return chk