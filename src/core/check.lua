local check = {}

-- check 'n' is natural number
function check.Natural(n)  return check.Number(n) and (n >= 0) end
-- check 'v' is a number
function check.Number(v)   return type(v) == 'number' end
-- check 'v' is a table
function check.Table(v)    return type(v) == 'table' end
-- check 'v' is a string
function check.String(v)   return type(v) == 'string' end
-- check 'v' is a string
function check.Boolean(v)  return type(v) == 'boolean' end
-- check 'v' is a function
function check.Fun(v)      return type(v) == 'function' end
-- check 'v' has meta T
function check.Is(v, T)    return tostring(getmetatable(v)) == tostring(T) end

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