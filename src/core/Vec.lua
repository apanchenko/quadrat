local object  = require 'src.core.object'
local types   = require 'src.core.types'
local Ass     = require 'src.core.Ass'

-- 2d vector
local vec = object:new()

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
  Ass.Is(min, vec)
  Ass.Is(max, vec)
  return setmetatable({x = math.random(min.x, max.x), y = math.random(min.y, max.y)}, vec)
end
--
function vec:from(obj)
  return vec:new(obj.x, obj.y)
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
  
  local a = vec(1, 2)
  local b = vec(3, 4)
  local c = b - a

  assert(a.x == 1 and a.y == 2)
  assert(a:length2() == 5)
  assert(c.x == 2 and c.y == 2)
  assert(vec(2.3, 4.5):round().x == 2)

  local d = vec(-1.5, -0.5)
  Ass(d:abs().x == 1.5)
end

Ass.Wrap(vec, ':length2')
Ass.Wrap(vec, ':round')
Ass.Wrap(vec, ':to', types.tab)

-- return module
return vec