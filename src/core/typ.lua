-- simple types
local any = {name='any', is = function(v) return v ~= nil end} -- not nil
local nul = {name='nul', is = function(v) return v == nul end}
local boo = {name='boo', is = function(v) return type(v) == 'boolean' end}
local tab = {name='tab', is = function(v) return type(v) == 'table' end}
local num = {name='num', is = function(v) return type(v) == 'number' end}
local str = {name='str', is = function(v) return type(v) == 'string' end}
local fun = {name='fun', is = function(v) return type(v) == 'function' end}

-- tab or smth
function tab.__add(l, r)
  return
  {
    name = l.name..'|'..r.name,
    is = function(v) return l.is(v) or r.is(v) end
  }
end


return
{
  any = any,
  boo = boo,
  tab = tab,
  num = num,
  str = str,
  fun = fun,

  -- check if t is one of simple types
  is_simple = function(t)
    return t==any or t==boo or t==tab or t==num or t==str or t==fun
  end,

  -- create type that has metatable mt
  meta = function(mt)
    return
    {
      name = tostring(mt),
      is = function(v)
        repeat v = getmetatable(v)
          if v == nil then
            return false
          end
        until v ~= mt
        return true
      end
    }
  end,

  -- create type that has named metatable
  metaname = function(name)
    return
    {
      name = name,
      is = function(v) return tostring(getmetatable(v)) == name end
    }
  end
}