local obj   = require 'src.core.obj'
local typ   = require 'src.core.typ'
local ass   = require 'src.core.ass'
local wrp   = require 'src.core.wrp'
local log   = require 'src.core.log'

-- 2d vector
local vec = obj:extend('vec')
vec.x = 0
vec.y = 0

-- stateless ------------------------------------------------------------------
--
function vec.copy(from, to)
  to.x = from.x
  to.y = from.y
end
--
function vec.center(obj)
  obj.x = display.contentWidth / 2
  obj.y = display.contentHeight / 2
end
--
function vec.__add(l, r) return vec:new(l.x + r.x, l.y + r.y) end
function vec.__sub(l, r) return vec:new(l.x - r.x, l.y - r.y) end
function vec.__div(l, r) return vec:new(l.x / r.x, l.y / r.y) end
function vec.__mul(l, r) return vec:new(l.x * r.x, l.y * r.y) end
function vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-- create ---------------------------------------------------------------------
-- x, y
function vec:new(x, y)
  return obj.new(self, {x = x, y = y})
end
-- random
function vec:random(min, max)
  return setmetatable({x = math.random(min.x, max.x), y = math.random(min.y, max.y)}, vec)
end
--
function vec:from(obj)
  return vec(obj.x, obj.y)
end

-- methods ---------------------------------------------------------------------
--
function vec:__tostring()
  return '{'.. self.x.. ",".. self.y.. '}'
end
-- square length
function vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end
-- round x,y to closest integer values
function vec:round()
  return vec:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end
-- copy x,y into obj
function vec:to(obj)
  obj.x = self.x
  obj.y = self.y
end
-- turn positive
function vec:abs()
  return vec:new(math.abs(self.x), math.abs(self.y))
end

-- constants ------------------------------------------------------------------
vec.zero = vec(0, 0)
vec.one = vec(1, 1)

-- module ---------------------------------------------------------------------
-- wrap vec functions
function vec.wrap()
  local opts = { static = true, log = log.info }
  wrp.fn(vec, 'copy', {{'from', typ.tab}, {'to', typ.tab}}, opts)
  wrp.fn(vec, 'center', {{'obj', typ.tab}}, opts)
  opts.static = false
  wrp.fn(vec, 'new', {{'x', typ.num}, {'y', typ.num}}, opts)
  wrp.fn(vec, 'random', {{'min', vec}, {'max', vec}}, opts)
  wrp.fn(vec, 'from', {{'obj', typ.tab}}, opts)
  wrp.fn(vec, 'length2', {}, opts)
  wrp.fn(vec, 'round', {}, opts)
  wrp.fn(vec, 'to', {{'obj', typ.tab}}, opts)
  wrp.fn(vec, 'abs', {}, opts)
end

-- selftest
function vec.test()
  assert(tostring(vec.one) == '{1,1}')
  
  local a = vec(2, 2)
  local b = vec(3, 4)
  local c = b - a

  assert(a.x == 2 and a.y == 2)
  assert(a:length2() == 8)
  assert(c.x == 1 and c.y == 2)
  assert(vec(2.3, 4.5):round().x == 2)

  local d = vec(-1.5, -0.5)
  ass(d:abs().x == 1.5)
end

-- return module
return vec