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

return map