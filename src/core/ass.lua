local typ = require 'src.core.typ'

local m = {}

-- 'v' is true
function m:__call(v, msg)   return v or error(msg or tostring(v)..' is false') end

local ass = setmetatable({}, m)

-- 'v' is nil
function ass.nul(v, msg)    return v == nil or error(msg or tostring(v)..' is not nil') end
-- 'v' is not nil
function ass.NotNil(v, msg) return v ~= nil or error(msg or 'value is nil') end
-- 'v' is a number
function ass.num(v, msg)    return typ.num(v) or error(msg or tostring(v)..' is not a number') end
-- 'n' is natural number
function ass.nat(v, msg)    return typ.nat(v) or error(msg or tostring(v)..' is not natural') end
-- 'v' is a table
function ass.tab(v, msg)    return typ.tab(v) or error(msg or tostring(v)..' is not a table') end
-- 'v' is a string
function ass.str(v)         return typ.str(v) or error(tostring(v)..' is not a string') end
-- 'v' is a boolean
function ass.bool(v)        return typ.boo(v) or error(tostring(v)..' is not a boolean') end
-- 'v' is a function
function ass.fun(v, msg)    return typ.fun(v) or error(msg or tostring(v)..' is not a function') end
-- 'v' is an instance of T
--function ass.is(t, T, msg)  return typ.is(t, T) or error(msg or tostring(t)..' is not '..tostring(T)) end
--
function ass.eq(a, b, msg)  return a == b or error(msg or tostring(a).. ' ~= '.. tostring(b)) end
function ass.ne(a, b, msg)  return a ~= b or error(msg or tostring(a).. ' == '.. tostring(b)) end
function ass.le(a, b, msg)  return a <= b or error(msg or tostring(a).. ' > ' .. tostring(b)) end
function ass.gt(a, b, msg)  return a >  b or error(msg or tostring(a).. ' <= '.. tostring(b)) end
function ass.ge(a, b, msg)  return a >= b or error(msg or tostring(a).. ' > ' .. tostring(b)) end

-- all tests in package

return ass