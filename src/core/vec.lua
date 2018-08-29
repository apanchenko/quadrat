local vec = {}
vec.__index = vec
setmetatable(vec, {__call = function(cls, ...) return cls.new(...) end})

-- x, y  - vecition
-------------------------------------------------------------------------------
function vec.new(x, y)
  return setmetatable({x = x or 0, y = (y or x) or 0}, vec)
end

-------------------------------------------------------------------------------
function vec.from(obj)
  return vec.new(obj.x, obj.y)
end

-------------------------------------------------------------------------------
function vec.copy(from, to)
  to.x = from.x
  to.y = from.y
end

-------------------------------------------------------------------------------
function vec.center(obj)
  obj.x = display.contentWidth / 2
  obj.y = display.contentHeight / 2
end

-------------------------------------------------------------------------------
function vec.__add(l, r) return vec.new(l.x + r.x, l.y + r.y) end
function vec.__sub(l, r) return vec.new(l.x - r.x, l.y - r.y) end
function vec.__div(l, r) return vec.new(l.x / r.x, l.y / r.y) end
function vec.__mul(l, r) return vec.new(l.x * r.x, l.y * r.y) end
function vec.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function vec.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function vec.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-------------------------------------------------------------------------------
function vec:__tostring()
  return self.x..","..self.y
end
-------------------------------------------------------------------------------
function vec:typename()
  return "vec"
end

-------------------------------------------------------------------------------
function vec:length2()
  return (self.x * self.x) + (self.y * self.y)
end

-------------------------------------------------------------------------------
function vec:round()
  return vec.new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end

-------------------------------------------------------------------------------
function vec:to(obj)
  obj.x = self.x
  obj.y = self.y
end

-------------------------------------------------------------------------------
function vec.test()
  local a = vec.new(3, 4)
  local b = vec.new(2, 3)

  assert(a.x == 3 and a.y == 4)
  assert((a-b).x == 1 and (a-b).y == 1)

  assert(b:length2() == 13)
  assert(vec.new(2.3, 4.5):round().x == 2)
end

-------------------------------------------------------------------------------
return vec