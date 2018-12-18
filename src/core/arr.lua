local ass   = require 'src.core.ass'
local typ   = require 'src.core.typ'

local arr = {}

function arr.is_empty(t)
  return next(t) == nil
end
--
function arr.add(t, v)
  t[#t + 1] = v
end

--
function arr.all(t, fn)
  for i = 1, #t do
    if not fn(t[i]) then
      return false
    end
  end
  return true
end

--
function arr.each(t, fn)
  for i = 1, #t do
    fn(t[i])
  end
end
--
function arr.map(t, fn)
  local mapped = {}
  for i = 1, #t do
    mapped[i] = fn(t[i])
  end
  return mapped
end
--
function arr.reduce(t, memo, fn)
  for i = 1, #t do
    memo = fn(memo, t[i])
  end
  return memo
end


-- return random element of table
function arr.random(t)
  return t[math.random(#t)]
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(arr, '.add', typ.tab, typ.any)
ass.wrap(arr, '.all', typ.tab, typ.fun)
ass.wrap(arr, '.each', typ.tab, typ.fun)
ass.wrap(arr, '.random', typ.tab)

return arr