-- gather various functions
local cor = {}

-- assert 'v' is true
function cor.assert(v, msg)
  if v then
    return
  end
  error(msg) 
end

-- 't' has metatable 'mt'
function cor.is(t, mt)
  while t ~= mt do
    if t == nil then
      return false
    end
    t = getmetatable(t)
  end
  return true
end

return cor