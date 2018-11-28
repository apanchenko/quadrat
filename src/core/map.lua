local Ass = require 'src.core.Ass'

local map = {}

function map.any(table, fn)
  Ass.Table(table)
  Ass.Fun(fn)
  for k, v in pairs(table) do
    if fn(v) then
      return true
    end
  end
  return false
end

function map.all(table, fn)
  Ass.Table(table)
  Ass.Fun(fn)
  for k, v in pairs(table) do
    if not fn(v) then
      return false
    end
  end
  return true
end

function map.each(table, fn)
  Ass.Table(table)
  Ass.Fun(fn)
  for k, v in pairs(table) do
    fn(v)
  end
end

-- number of elements in table
function map.count(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

-- return random element of table
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

return map