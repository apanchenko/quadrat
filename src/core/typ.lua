-- check if value v has metatable mt
local is = function(v, mt)
  print('-----   is '.. tostring(v).. ' of '.. tostring(mt))
  while v ~= mt do
    if v == nil then
      return false
    end
    v = getmetatable(v)
  end
  return true
end

-- create typ
local str = function() return 'typ' end
local typmt = { __tostring = str }
typmt = setmetatable(typmt, { __tostring = str })
typmt.__call = function(t, v) return is(v, typmt) end
local typ = setmetatable({}, typmt)

-- describe type by name and checking fn 
local make_type = function(name, check_fn)
  -- create own table, do not modify typ
  local mymt = setmetatable({}, typ)
  mymt.__tostring = function() return name end
  mymt.__call = function(_, v) return check_fn(v) end
  return setmetatable({}, mymt)
end


-- tab or smth
--function tab.__add(l, r)
--  local name = tostring(l)..'|'..tostring(r),
--  local is = function(v) return l(v) or r(v) end
--  return make_type(name, is)
--end

  -- simple types
typ.any = make_type('any', function(v) return v ~= nil end, typ)
typ.boo = make_type('boo', function(v) return type(v) == 'boolean' end, typ)
typ.tab = make_type('tab', function(v) return type(v) == 'table' end, typ)
typ.num = make_type('num', function(v) return type(v) == 'number' end, typ)
typ.str = make_type('str', function(v) return type(v) == 'string' end, typ)
typ.fun = make_type('fun', function(v) return type(v) == 'function' end, typ)
typ.nat = make_type('nat', function(v) return type(v) == 'number' and v >= 0 and math.floor(v) == v end, typ)


-- check if t is one of simple types
function typ.is_simple(t)
  return t==any or t==boo or t==tab or t==num or t==str or t==fun or t==nat
end

-- create type that has metatable mt
function typ.meta(mt)
  return make_type(tostring(mt), is)
end

-- create type that has named metatable
function typ.metaname(name)
  return make_type(name, function(v) return tostring(getmetatable(v)) == name end)
end

-- test
function typ.test()
  print('typ.test')
  return
        (typ(typ) or error('typ is not typ'))
    and (typ({})==false or error('{} is typ'))
    and (tostring(typ)=='typ' or error('invalid typ name'))

    and (typ(typ.any) or error('any is not typ'))
    and (typ(typ.boo) or error('boo is not typ'))
    and (typ(typ.tab) or error('tab is not typ'))
    and (typ(typ.num) or error('num is not typ'))

    and (typ(typ.str) or error('str is not typ'))
    and (typ.str('')  or error('empty string is not str'))

    and (typ(typ.fun) or error('fun is not typ'))
    and (typ(typ.nat) or error('nat is not typ'))
end

return typ