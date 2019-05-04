local cor = require 'src.core.cor'

-- typ metatable
local mt = {}

-- support tostring(typ)
function mt:__tostring()
  return 'typ'
end

-- create typ
local typ = setmetatable({}, mt)

-- typ(x) tells if x is typ
function mt:__call(v)
  return cor.is(v, typ)
end

-- describe type by name and checking function
function typ:new(name, check_fn)
  print('typ:new '..name.. ' check '..tostring(check_fn))
  -- create own table, do not modify typ
  local mymt = setmetatable({}, self)
  mymt.__tostring = function() return name end
  
  function mymt:__call(v)
    --print(name..'('..tostring(v)..' ['..type(v)..']) check '..tostring(check_fn).. ' -> '.. tostring(check_fn(v)))
    return check_fn(v)
  end
  return setmetatable({}, mymt)
end

-- tab or smth
--function tab.__add(l, r)
--  local name = tostring(l)..'|'..tostring(r),
--  local is = function(v) return l(v) or r(v) end
--  return make_type(name, is)
--end

-- check type(v)
local get_istype = function(typename)
  return function(v)
    --print('typ.istype('..tostring(v)..' ['..type(v)..'], '..tostring(typename)..')')
    return type(v) == typename
  end
end

-- simple types
typ.any = typ:new('typ.any', function(v) return v ~= nil end, typ)
typ.boo = typ:new('typ.boo', get_istype('boolean'))
typ.tab = typ:new('typ.tab', get_istype('table'))
typ.num = typ:new('typ.num', get_istype('number'))
typ.str = typ:new('typ.str', get_istype('string'))
typ.fun = typ:new('typ.fun', get_istype('function'))
typ.nat = typ:new('typ.nat', function(v) return type(v) == 'number' and v >= 0 and math.floor(v) == v end, typ)


-- check if t is one of simple types
function typ.is_simple(t)
  return t==any or t==boo or t==tab or t==num or t==str or t==fun or t==nat
end

-- create type that has metatable mt
function typ.meta(mt)
  local res = typ:new(tostring(mt), function(v) return cor.is(v, mt) end)
  print('typ.meta('..tostring(mt)..') -> '.. tostring(res))
  return res
end

-- create type that has named metatable
function typ.metaname(name)
  local res = typ:new(name, function(v) return tostring(getmetatable(v)) == name end)
  print('typ.metaname('..name..') -> '.. tostring(res))
  return res
end

-- all tests in package

return typ