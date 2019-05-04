local pkg = require 'src.core.pkg'

local cor = pkg:new('src.core')

cor:load('arr', 'ass', 'chk', 'cnt', 'env', 'evt', 'lay', 'log', 'map', 'obj', 'typ', 'vec', 'wrp')

--
function cor:wrap()
  local log = self:get('log')
  local ass = self:get('ass')
  local typ = self:get('typ')
  local wrp = self:get('wrp')
  local arr = self:get('arr')

  local depth = log:info('cor.wrap'):enter()

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

  log:exit(depth)

  pkg.wrap(cor)
end

--
function cor:test()
  local arr = cor:get('arr')
  local log = cor:get('log')
  local ass = cor:get('ass')
  local typ = cor:get('typ')
  -- typ
  ass(tostring(typ)=='typ',  'invalid typ name')
  ass(typ(typ),              'typ is not typ')
  ass(typ({})==false,        '{} is typ')
  -- typ.any
  ass(tostring(typ.any)=='typ.any', 'invalid any name')
  ass(typ(typ.any),          'any is not typ')
  ass(typ.any({}),           '{} is not any')
  ass(typ.any(nil)==false,   'nil is any')
  -- typ.boo
  ass(typ(typ.boo),          'boo is not typ')
  ass(typ.boo(true),         'true is not bool')
  ass(typ.boo(false),        'false is not bool')
  -- typ.tab
  ass(typ(typ.tab),          'tab is not typ')
  ass(typ.tab({}),           '{} is not table')
  -- typ.num
  ass(typ(typ.num),          'num is not typ')
  -- typ.str
  ass(typ(typ.str),          'str is not typ')
  ass(typ.str(''),           'empty string is not str')
  ass(typ.str(1)==false,     '1 is not str')
  ass(typ.str(nil)==false,   'nil is not str')

  ass(typ(typ.fun),          'fun is not typ')
  ass(typ(typ.nat),          'nat is not typ')

    --and (typ.meta())

  ass(true)
  ass.nul(x)
  ass.num(8.8)
  ass.nat(9)
  ass.tab({})
  ass.str("String")
  ass.bool(false)
  ass.fun(function() end)

  ass.eq(arr.tostring({'semana','mes','ano'}), 'semana, mes, ano')
  local compare = function(a, b) return a < b end
  ass.eq(arr.find_index({1},     1, 2, 0, compare), 1, 'test find_index - front')
  ass.eq(arr.find_index({1,3},   1, 3, 2, compare), 2, 'test find_index - middle')
  ass.eq(arr.find_index({1},     1, 2, 2, compare), 2, 'test find_index - back')
  ass.eq(arr.find_index({},      1, 1, 9, compare), 1, 'test find_index - empty')


  pkg.test(cor)
end

return cor