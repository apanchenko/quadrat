local impl = require 'src.core.impl.arr'

local arr =
{
  is_empty      = impl.is_empty,
  push          = impl.push,
  pop           = impl.pop,
  shift         = impl.shift,
  unshift       = impl.unshift,
  each          = impl.each,
  tostring      = impl.tostring,
  map           = impl.map,
  reduce        = impl.reduce,
  detect        = impl.detect,
  select        = impl.select,
  reject        = impl.reject,
  all           = impl.all,
  any           = impl.any,
  include       = impl.include,
  invoke        = impl.invoke,
  pluck         = impl.pluk,
  min           = impl.min,
  max           = impl.max,
  reverse       = impl.reverse,
  first         = impl.first,
  rest          = impl.rest,
  slice         = impl.slice,
  flatten       = impl.flatten,
  join          = impl.join,
  random        = impl.random,
  remove_random = impl.remove_random, -- remove and return random element
  find_index    = impl.find_index
}

-- MODULE ---------------------------------------------------------------------
function arr:wrap()
  local typ   = require 'src.core.typ'
  local wrp   = require 'src.core.wrp'
  local log   = require 'src.core.log'

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
  local ass   = require 'src.core.ass'

  ass.eq(arr.tostring({'semana','mes','ano'}), 'semana, mes, ano')

  local compare = function(a, b) return a < b end
  ass.eq(arr.find_index({1},     1, 2, 0, compare), 1, 'test find_index - front')
  ass.eq(arr.find_index({1,3},   1, 3, 2, compare), 2, 'test find_index - middle')
  ass.eq(arr.find_index({1},     1, 2, 2, compare), 2, 'test find_index - back')
  ass.eq(arr.find_index({},      1, 1, 9, compare), 1, 'test find_index - empty')
end

return arr