local ass =
{
  typename = "ass"
}

-- check 'num' is natural number
function ass.natural(num)
  ass.type(num, "number")
  assert(num >= 0)
end

-- check 'value' is a string
function ass.string(value, name)
  ass.type(value, "string", name)
end

-- check 'value' is a basic type
function ass.type(value, typename, name)
  name = name or "value"
  assert(value ~= nil, name.. " is nil")
  assert(type(value) == typename, "type ".. type(value).. ", expected ".. typename)
end

-- check value is a table with field 'typename'
function ass.is(value, typename)
  ass.type(value, "table")
  ass.type(value.typename, "string")
  assert(value.typename == typename, "typename ".. value.typename.. ", expected ".. typename)
end

return ass