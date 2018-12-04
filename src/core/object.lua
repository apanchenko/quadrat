local ass   = require 'src.core.Ass'
local log   = require 'src.core.log'
local types = require 'src.core.types'

-------------------------------------------------------------------------------
local object = {}
--
function object.__call(cls, ...)
  return cls:create(...)
end
--
function object:__tostring()
  return self.name or 'object'
end
--
function object:new(def)
  def = def or {}
  setmetatable(def, self)
  self.__index = self
  return def
end

-- selftest -------------------------------------------------------------------
ass.Wrap(object, ':new', types.str, types.tab)
--
function object.test()
  log:trace("object.test")

  local account = object:new({ name = 'account', balance = 0 })
  function account:__tostring()
    return 'account '..self.balance
  end
  function account:deposit(v)
    self.balance = self.balance + v
  end

  ass(tostring(account) == 'account')

  local limit = account:new({ name = 'limit', limit = 100 })
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
  ass(tostring(masha) == 'account 30')

  local kolya = limit:new()
  kolya:deposit(120)
  ass(tostring(kolya) == 'limit account 100 of 100')

  ass(getmetatable(account) == object)
  ass(getmetatable(masha) == account)
  ass(getmetatable(limit) == account)
  ass(getmetatable(kolya) == limit)
end

return object