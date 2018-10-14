local Vec =
{
  typename = "Vec"
}
Vec.__index = Vec
setmetatable(Vec, {__call = function(cls, ...) return cls.new(...) end})

-- x, y  - Vecition
-------------------------------------------------------------------------------
function Vec.new(x, y)
  return setmetatable({x = x or 0, y = (y or x) or 0}, Vec)
end

-- equals
function Vec:equals(v)
  return self.x == v.x and self.y == v.y
end
-------------------------------------------------------------------------------
function Vec.from(obj)
  return Vec.new(obj.x, obj.y)
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
function Vec.__add(l, r) return Vec.new(l.x + r.x, l.y + r.y) end
function Vec.__sub(l, r) return Vec.new(l.x - r.x, l.y - r.y) end
function Vec.__div(l, r) return Vec.new(l.x / r.x, l.y / r.y) end
function Vec.__mul(l, r) return Vec.new(l.x * r.x, l.y * r.y) end
function Vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function Vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function Vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-------------------------------------------------------------------------------
function Vec:__tostring()
  return self.x..","..self.y
end
-------------------------------------------------------------------------------
function Vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end

-------------------------------------------------------------------------------
function Vec:round()
  return Vec.new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
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

-------------------------------------------------------------------------------
function Vec.test()
  local a = Vec.new(3, 4)
  local b = Vec.new(2, 3)

  assert(a.x == 3 and a.y == 4)
  assert((a-b).x == 1 and (a-b).y == 1)

  assert(b:length2() == 13)
  assert(Vec.new(2.3, 4.5):round().x == 2)
end

-------------------------------------------------------------------------------
return Vec