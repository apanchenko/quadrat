local ass =
{
  typename = "ass"
}

-- check 'value' is not nil
function ass.not_nil(value, name)
  name = name or "value"
  assert(value ~= nil, name.. ' is nil')
end
setmetatable(ass, {__call = function(cls, ...) return cls.not_nil(...) end})

-- check 'value' is nil
function ass.nul(value, name)
  name = name or "value"
  assert(value == nil, name.. " is not nil")
end

-- check 'num' is natural number
function ass.natural(num, message)
  ass.number(num, message)
  ass(num >= 0, message)
end

-- check 'value' is a number
function ass.number(value, name)
  ass.type(value, 'number', name)
end

-- check 'value' is a table
function ass.table(value, name)    ass.type(value, "table", name) end
-- check 'value' is a string
function ass.string(value, name)   ass.type(value, "string", name) end
-- check 'value' is a string
function ass.boolean(value, name)  ass.type(value, "boolean", name) end
-- check 'value' is a function
function ass.fn(value, name)       ass.type(value, "function", name) end

-- check 'value' is a basic type
function ass.type(value, typename, name)
  ass(value, name)
  assert(type(value) == typename, "type ".. type(value).. ", expected ".. typename)
end

-- check value is a table with field 'typename'
function ass.is(value, typename)
  if type(typename) ~= 'string' then
    typename = typename.typename
  end

  ass.table(value)
  ass.string(value.typename)
  assert(value.typename == typename, "typename ".. value.typename.. ", expected ".. typename)
end


return ass