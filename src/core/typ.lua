return
{
  any = {name='any', is = function(v) return v ~= nil end}, -- not nil
  tab = {name='tab', is = function(v) return type(v) == 'table' end},
  num = {name='num', is = function(v) return type(v) == 'number' end},
  str = {name='str', is = function(v) return type(v) == 'string' end},
  fun = {name='fun', is = function(v) return type(v) == 'function' end},

  meta = function(mt)
    return
    {
      name = tostring(mt),
      is = function(v) return getmetatable(v) == mt end
    }
  end,

  metaname = function(name)
    return
    {
      name = name,
      is = function(v) return tostring(getmetatable(v)) == name end
    }
  end
}