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

return arr