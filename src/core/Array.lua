local Ass   = require 'src.core.Ass'
local type  = require 'src.core.type'

local array = {}

--
function array.add(t, v)
  t[#t + 1] = v
end

--
function array.all(t, fn)
  for i = 1, #t do
    if not fn(t[i]) then
      return false
    end
  end
  return true
end

--
function array.each(table, fn)
  for i = 1, #t do
    fn(t[i])
  end
end

-- return random element of table
function array.random(t)
  return t[math.random(#t)]
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(array, 'add', type.tab, type.any)
Ass.Wrap(array, 'all', type.tab, type.fun)
Ass.Wrap(array, 'each', type.tab, type.fun)
Ass.Wrap(array, 'random', type.tab)

log:wrap(array)

return Array