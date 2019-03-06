local ass       = require 'src.core.ass'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'
local log       = require 'src.core.log'
local arr_impl  = require 'src.core.impl.arr'

local arr = {
  is_empty    = arr_impl.is_empty,
  push        = arr_impl.push,
  pop         = arr_impl.pop,
  shift       = arr_impl.shift,
  unshift     = arr_impl.unshift,
  each        = arr_impl.each,
  tostring    = arr_impl.tostring,
  map         = arr_impl.map,
  reduce      = arr_impl.reduce,
  detect      = arr_impl.detect,
  select      = arr_impl.select,
  reject      = arr_impl.reject,
  all         = arr_impl.all,
  any         = arr_impl.any,
  include     = arr_impl.include,
  invoke      = arr_impl.invoke,
  pluck       = arr_impl.pluk,
  min         = arr_impl.min,
  max         = arr_impl.max,
  reverse     = arr_impl.reverse,
  first       = arr_impl.first,
  rest        = arr_impl.rest,
  slice       = arr_impl.slice,
  flatten     = arr_impl.flatten,
  join        = arr_impl.join,
  random      = arr_impl.random,
  find_index  = arr_impl.find_index
}

-- MODULE ---------------------------------------------------------------------
function arr.wrap()
  local wrap = function(fn_name, ...)
    wrp.fn(arr, fn_name, {...}, {name='arr', static=true, log=log.info})
  end
  local t = {'t', typ.tab}
  local v = {'v', typ.any}
  local f = {'f', typ.fun}

  wrap('push',       t, v)
  wrap('all',        t, f)
  wrap('each',       t, f)
  wrap('random',     t)
  wrap('find_index', t, {'low', typ.num}, {'high', typ.num}, {'obj', typ.any}, {'is_lower', typ.fun})
end

--
function arr.test()
  ass.eq(arr.tostring({'semana','mes','ano'}), 'semana, mes, ano')

  local compare = function(a, b) return a < b end
  ass.eq(arr.find_index({1},     1, 2, 0, compare), 1, 'test find_index - front')
  ass.eq(arr.find_index({1,3},   1, 3, 2, compare), 2, 'test find_index - middle')
  ass.eq(arr.find_index({1},     1, 2, 2, compare), 2, 'test find_index - back')
  ass.eq(arr.find_index({},      1, 1, 9, compare), 1, 'test find_index - empty')
end

return arr