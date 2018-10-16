local ass = require 'src.core.ass'

local map = {}

function map.any(table, fn)
  ass.table(table)
  ass.fn(fn)
  for k, v in pairs(table) do
    if fn(v) then
      return true
    end
  end
  return false
end

function map.all(table, fn)
  ass.table(table)
  ass.fn(fn)
  for k, v in pairs(table) do
    if not fn(v) then
      return false
    end
  end
  return true
end

function map.each(table, fn)
  ass.table(table)
  ass.fn(fn)
  for k, v in pairs(table) do
    fn(v)
  end
end

return map