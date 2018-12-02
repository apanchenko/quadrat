local Ass = require 'src.core.Ass'
local Types = require 'src.core.Types'

local Array = {}

--
function Array.Add(t, v)
  t[#t + 1] = v
end

--
function Array.All(t, fn)
  for i = 1, #t do
    if not fn(t[i]) then
      return false
    end
  end
  return true
end

--
function Array.Each(table, fn)
  for i = 1, #t do
    fn(t[i])
  end
end

-- return random element of table
function Array.Random(t)
  return t[math.random(#t)]
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Array, 'Add', 'table', Types.Any)
Ass.Wrap(Array, 'All', 'table', Types.Fun)
Ass.Wrap(Array, 'Each', 'table', Types.Fun)
Ass.Wrap(Array, 'Random', 'table')

log:wrap(Array)

return Array