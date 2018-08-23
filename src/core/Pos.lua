local Pos = {}
Pos.__index = Pos
setmetatable(Pos, {__call = function(cls, ...) return cls.new(...) end})

-- x, y  - position
-------------------------------------------------------------------------------
function Pos.new(x, y)
  return setmetatable({x = x or 0, y = (y or x) or 0}, Pos)
end

-------------------------------------------------------------------------------
function Pos.from(obj)
  return Pos.new(obj.x, obj.y)
end

-------------------------------------------------------------------------------
function Pos.copy(from, to)
  to.x = from.x
  to.y = from.y
end

-------------------------------------------------------------------------------
function Pos.center(obj)
  obj.x = display.contentWidth / 2
  obj.y = display.contentHeight / 2
end

-------------------------------------------------------------------------------
function Pos.__add(l, r) return Pos.new(l.x + r.x, l.y + r.y) end
function Pos.__sub(l, r) return Pos.new(l.x - r.x, l.y - r.y) end
function Pos.__div(l, r) return Pos.new(l.x / r.x, l.y / r.y) end
function Pos.__mul(l, r) return Pos.new(l.x * r.x, l.y * r.y) end
function Pos.__eq (l, r) return (l.x == r.x) and (l.y == r.y) end
function Pos.__lt (l, r) return (l.x < r.x) and (l.y < r.y) end
function Pos.__le (l, r) return (l.x <= r.x) and (l.y <= r.y) end

-------------------------------------------------------------------------------
function Pos:__tostring()
  return self.x.."x"..self.y
end
-------------------------------------------------------------------------------
function Pos:typename()
  return "Pos"
end

-------------------------------------------------------------------------------
function Pos:length2()
  return (self.x * self.x) + (self.y * self.y)
end

-------------------------------------------------------------------------------
function Pos:round()
  return Pos.new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
end

-------------------------------------------------------------------------------
function Pos:to(obj)
  obj.x = self.x
  obj.y = self.y
end

-------------------------------------------------------------------------------
function Pos.test()
  local a = Pos.new(3, 4)
  local b = Pos.new(2, 3)

  assert(a.x == 3 and a.y == 4)
  assert((a-b).x == 1 and (a-b).y == 1)

  assert(b:length2() == 13)
  assert(Pos.new(2.3, 4.5):round().x == 2)
end

-------------------------------------------------------------------------------
return Pos