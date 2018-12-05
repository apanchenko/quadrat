local object  = require 'src.core.object'
local types   = require 'src.core.types'
local ass     = require 'src.core.ass'

-- 2d vector
local vec = object:new({ name = 'vec', x = 0, y = 0 })

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
function vec.__add(l, r) return vec:create(l.x + r.x, l.y + r.y) end
function vec.__sub(l, r) return vec:create(l.x - r.x, l.y - r.y) end
function vec.__div(l, r) return vec:create(l.x / r.x, l.y / r.y) end
function vec.__mul(l, r) return vec:create(l.x * r.x, l.y * r.y) end
function vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-- create ---------------------------------------------------------------------
-- x, y
function vec:create(x, y)
  local t = setmetatable({x = x, y = y}, self)
  self.__index = self
  return t
end
-- random
function vec:random(min, max)
  ass.is(min, vec)
  ass.is(max, vec)
  return setmetatable({x = math.random(min.x, max.x), y = math.random(min.y, max.y)}, vec)
end
--
function vec:from(obj)
  return vec(obj.x, obj.y)
end

-- methods ---------------------------------------------------------------------
--
function vec:__tostring()
  return '['.. self.x.. ",".. self.y.. ']'
end
--
function vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end
--
function vec:round()
  return vec:create(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end
--
function vec:to(obj)
  obj.x = self.x
  obj.y = self.y
end
-- turn positive
function vec:abs()
  return vec:create(math.abs(self.x), math.abs(self.y))
end

-- constants ------------------------------------------------------------------
vec.zero = vec(0, 0)
vec.one = vec(1, 1)

-- selftest
function vec.test()
  print('vec.test..')
  assert(tostring(vec.one) == '[1,1]')
  
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

ass.wrap(vec, '.copy', types.tab, types.tab)
ass.wrap(vec, '.center', types.tab)
ass.wrap(vec, ':create', types.num, types.num)
ass.wrap(vec, ':random', vec, vec)
ass.wrap(vec, ':from', types.tab)
ass.wrap(vec, ':length2')
ass.wrap(vec, ':round')
ass.wrap(vec, ':to', types.tab)
ass.wrap(vec, ':abs')

-- return module
return vec