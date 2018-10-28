local check = { typename = "check" }

-- check 'n' is natural number
function check.natural(n)  return check.number(n) and (n >= 0) end
-- check 'v' is a number
function check.number(v)   return type(v) == 'number' end
-- check 'v' is a table
function check.table(v)    return type(v) == 'table' end
-- check 'v' is a string
function check.string(v)   return type(v) == 'string' end
-- check 'v' is a string
function check.boolean(v)  return type(v) == 'boolean' end
-- check 'v' is a function
function check.fun(v)      return type(v) == 'function' end

-- check value is a table with field 'typename'
function check.is(t, typename)
  if type(typename) == 'table' then
    typename = typename.typename
  end
  return check.table(t) and check.string(t.typename) and t.typename == typename
end


return check