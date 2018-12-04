local Ass   = require 'src.core.Ass'
local types = require 'src.core.types'

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
Ass.Wrap(array, '.add', types.tab, types.any)
Ass.Wrap(array, '.all', types.tab, types.fun)
Ass.Wrap(array, '.each', types.tab, types.fun)
Ass.Wrap(array, '.random', types.tab)

log:wrap(array)

return Array