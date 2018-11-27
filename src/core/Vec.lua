local Ass = require 'src.core.Ass'

local Vec = setmetatable({},
{
  __tostring = function()         return 'Vec' end,
  __call     = function(cls, ...) return cls.New(...) end
})
Vec.__index = Vec

-- x, y
function Vec.New(x, y)
  return setmetatable({x = x or 0, y = (y or x) or 0}, Vec)
end
-- random vector
function Vec.Random(x1, y1, x2, y2)
  return setmetatable({x = math.random(x1, x2), y = math.random(y1, y2)}, Vec)
end

-------------------------------------------------------------------------------
function Vec.from(obj)
  return Vec.New(obj.x, obj.y)
end

-------------------------------------------------------------------------------
function Vec.copy(from, to)
  to.x = from.x
  to.y = from.y
end

-------------------------------------------------------------------------------
function Vec.center(obj)
  obj.x = display.contentWidth / 2
  obj.y = display.contentHeight / 2
end

-------------------------------------------------------------------------------
function Vec.__add(l, r) return Vec.New(l.x + r.x, l.y + r.y) end
function Vec.__sub(l, r) return Vec.New(l.x - r.x, l.y - r.y) end
function Vec.__div(l, r) return Vec.New(l.x / r.x, l.y / r.y) end
function Vec.__mul(l, r) return Vec.New(l.x * r.x, l.y * r.y) end
function Vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function Vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function Vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-------------------------------------------------------------------------------
function Vec:__tostring()
  return '['.. self.x.. ",".. self.y.. ']'
end
-------------------------------------------------------------------------------
function Vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end

-------------------------------------------------------------------------------
function Vec:round()
  return Vec.New(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end

-------------------------------------------------------------------------------
function Vec:to(obj)
  obj.x = self.x
  obj.y = self.y
end

-- turn positive
function Vec:abs()
  return Vec.new(math.abs(self.x), math.abs(self.y))
end

-- test if v is Vec
function Vec.is_valid(v)
  return v~=nil and v.typename==Vec.typename and type(v.x)=='number' and type(v.y)=='number'
end

Vec.Zero = Vec.New(0, 0)

-- selftest
function Vec.Test()
  print('test Vec..')
  local a = Vec.New(3, 4)
  local b = Vec.New(2, 3)

  assert(a.x == 3 and a.y == 4)
  assert((a-b).x == 1 and (a-b).y == 1)

  assert(b:length2() == 13)
  assert(Vec.New(2.3, 4.5):round().x == 2)
end

Ass.Wrap(Vec, 'length2')
Ass.Wrap(Vec, 'round')
Ass.Wrap(Vec, 'to', 'table')

-- return module
return Vec