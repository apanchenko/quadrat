local Pos = {}

-- x, y  - integer, position on board
-------------------------------------------------------------------------------
function Pos.new(x, y)
  local self = {x = x or 0, y = y or 0}

  setmetatable(self, {
    __sub = function(l, r)
      return Pos.new(l.x - r.x, l.y - r.y)
    end,
    __tostring = function(s)
      return s.x..","..s.y
    end
  })

  function self:length2()
    return (self.x * self.x) + (self.y * self.y)
  end

  function self:round()
    return Pos.new(math.floor(self.x + 0.5), math.floor(self.y + 0.5))
  end

return self
end

-------------------------------------------------------------------------------
function Pos.test()
  local a = Pos.new(3, 4)
  assert(a.x == 3 and a.y == 4)

  local b = Pos.new(2, 3)
  local c = a - b
  assert(c.x == 1 and c.y == 1)
end

-------------------------------------------------------------------------------
return Pos