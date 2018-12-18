local ass   = require 'src.core.ass'
local typ = require 'src.core.typ'
local log   = require 'src.core.log'

-- name to value
local map = setmetatable({}, {__tostring = function() return 'map' end})

-- or
function map.any(t, fn)
  for k, v in pairs(t) do
    if fn(v) then
      return true
    end
  end
  return false
end

-- and
function map.all(t, fn)
  for k, v in pairs(t) do
    if not fn(v) then
      return false
    end
  end
  return true
end

-- call fn with every element
function map.each(t, fn)
  for k, v in pairs(t) do
    fn(v)
  end
end

-- number of elements
function map.count(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

-- random element of table
function map.random(t)
  local count = map.count(t)
  if count == 0 then
    return nil
  end

  local i = math.random(count) -- 1..count
  for k, v in pairs(t) do
    i = i - 1
    if i == 0 then
      return v
    end
  end
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(map, '.all', typ.tab, typ.fun)
ass.wrap(map, '.each', typ.tab, typ.fun)
ass.wrap(map, '.count', typ.tab)
ass.wrap(map, '.random', typ.tab)

log:wrap(map)

--
function map.test()
  log:trace("map.test")

  ass(tostring(map) == 'map')
  local t = {}
  t['week'] = 'semana'
  t['month'] = 'mes'
  t['year'] = 'ano'

  --ass(map.each(t, function(v) log:trace(v) end))
  ass(map.any(t, function(v) return #v > 3 end))
  ass(map.all(t, function(v) return #v > 2 end))
  ass(map.count(t) == 3)
end


return map