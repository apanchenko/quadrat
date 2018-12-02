local Ass = require 'src.core.Ass'
local log = require 'src.core.log'

-------------------------------------------------------------------------------
local object = {}

function object:__tostring()
  return 'object'
end

function object:new(t)
  t = t or {}
  Ass.Table(t)
  setmetatable(t, self)
  self.__index = self
  return t
end


-- selftest -------------------------------------------------------------------
function object.test()
  log:trace("object.test")

  local account = object:new({ balance = 0 })
  function account:__tostring()
    return 'account '..self.balance
  end
  function account:deposit(v)
    self.balance = self.balance + v
  end

  local limit = account:new({ limit = 100 })
  function limit:__tostring()
    return 'limit account '..self.balance..' of '..self.limit
  end
  function limit:deposit(v)
    if self.balance + v > self.limit then
      self.balance = self.limit
    else
      self.balance = self.balance + v
    end
  end

  local masha = account:new()
  masha:deposit(30)
  Ass(tostring(masha) == 'account 30')

  local kolya = limit:new()
  kolya:deposit(120)
  Ass(tostring(kolya) == 'limit account 100 of 100')

  Ass(getmetatable(account) == object)
  Ass(getmetatable(masha) == account)
  Ass(getmetatable(limit) == account)
  Ass(getmetatable(kolya) == limit)
end

return object