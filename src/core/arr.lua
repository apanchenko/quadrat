-- thanks to Marcus Irven

local ass   = require 'src.core.ass'
local typ   = require 'src.core.typ'
local wrp   = require 'src.core.wrp'
local log   = require 'src.core.log'

local arr = {}

function arr.is_empty(t)
  return next(t) == nil
end
--
function arr.push(t, v)
  t[#t + 1] = v
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
--
function arr.detect(t, fn)
  for i = 1, #t do
    if fn(t[i]) then
      return i
    end
  end
end
--
function arr.select(t, fn)
  local selected = {}
  for i = 1, #t do
    if fn(t[i]) then
      selected[#selected + 1] = t[i]
    end
  end
  return selected
end
--
function arr.reject(t, fn)
  local selected = {}
  for i = 1, #t do
    if not fn(t[i]) then
      selected[#selected + 1] = t[i]
    end
  end
  return selected
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
function arr.any(t, fn)
  for i = 1, #t do
    if fn(t[i]) then
      return true
    end
  end
  return false
end
--
function arr.include(t, value)
  for i = 1, #t do
    if t[i] == value then
      return true end
  end
  return false
end
--
function arr.invoke(t, fn_name, ...)
  local args = {...}
  arr.each(t, function(x) x[fn_name](unpack(args)) end)
end
--
function arr.pluck(t, name)
  return arr.map(t, function(x) return x[name] end)
end
--
function arr.min(t, fn)
  return arr.reduce(t, {}, function(min, x) 
    local value = fn(x)
    if min.item == nil then
      min.item = x
      min.value = value
    else
      if value < min.value then
        min.item = x
        min.value = value
      end
    end
    return min
  end).item
end
--
function arr.max(t, fn)
  return arr.reduce(t, {}, function(min, x) 
    local value = fn(x)
    if min.item == nil then
      min.item = x
      min.value = value
    else
      if value > min.value then
        min.item = x
        min.value = value
      end
    end
    return min
  end).item
end
--
function arr.reverse(t)
  local reversed = {}
  for i = 1, #t do
    table.insert(reversed, 1, t[i])
  end
  return reversed
end
--
function arr.first(array, n)
  if n == nil then
    return array[1]
  end
  local first = {}
  n = math.min(n, #array)
  for i = 1, n do
    first[i] = array[i]
  end
  return first
end
--
function arr.rest(array, index)
  index = index or 2
  local rest = {}
  for i = index, #array do
    rest[#rest + 1] = array[i]
  end
  return rest
end
--
function arr.slice(array, index, length)
  local sliced = {}
  index = math.max(index, 1)
  local end_index = math.min(index + length - 1, #array)
  for i = index, end_index do
    sliced[#sliced + 1] = array[i]
  end
  return sliced
end
--
function arr.flatten(array)
  local all = {}
  for i = 1, #array do
    if type(array[i]) == "table" then
      local flattened = arr.flatten(array[i])
      arr.each(flattened, function(e) all[#all + 1] = e end)
    else
      all[#all + 1] = array[i]
    end
  end
  return all
end
--
function arr.pop(array)
  return table.remove(array)
end
--
function arr.shift(array)
  return table.remove(array, 1)
end
--
function arr.unshift(array, item)
  table.insert(array, 1, item)
  return array
end
--
function arr.join(array, separator)
  return table.concat(array, separator)
end
-- return random element of table
function arr.random(t)
  return t[math.random(#t)]
end

-- to string
function arr.tostring(t, sep)
  sep = sep or ', '
  if #t == 0 then
    return ''
  end
  local res = tostring(t[1])
  for i = 2, #t do
    res = res.. sep.. tostring(t[i])
  end
  return res
end

-- MODULE ---------------------------------------------------------------------
function arr.wrap()
  wrp.fn(arr, 'push', {{'t', typ.tab}, {'v', typ.any}}, 'arr', true)
  wrp.fn(arr, 'all', {{'t', typ.tab}, {'fn', typ.fun}}, 'arr', true)
  wrp.fn(arr, 'each', {{'t', typ.tab}, {'fn', typ.fun}}, 'arr', true)
  wrp.fn(arr, 'random', {{'t', typ.tab}}, 'arr', true)
end

--
function arr.test()
  local t = { 'semana', 'mes', 'ano' }
  ass.eq(arr.tostring(t), 'semana, mes, ano')
end

return arr