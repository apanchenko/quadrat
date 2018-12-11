local ass   = require 'src.core.ass'
local log   = require 'src.core.log'
local types = require 'src.core.types'

-------------------------------------------------------------------------------
local object = setmetatable({}, {__tostring = function() return 'object' end})

--
function object.__call(cls, ...)
  return cls:create(...)
end
--
function object:__tostring()
  return self.name
end
--
function object:extend(name)
  local sub = setmetatable({name=name}, self)
  self.__index = self
  function sub:__tostring() return self.name end
  return sub
end
--
function object:create(def)
  ass.is(def, types.tab, 'object:new('..tostring(def)..')')
  setmetatable(def, self)
  self.__index = self
  return def
end

-- selftest -------------------------------------------------------------------
ass.wrap(object, ':extend', types.str)
--ass.wrap(object, ':new', types.tab)

--
function object.test()
  ass(tostring(object))

  local account = object:extend('account')
  account.balance = 0

  function account:__tostring()
    return 'account '..self.balance
  end
  function account:deposit(v)
    self.balance = self.balance + v
  end

  ass(tostring(account) == 'account')

  local limit = account:extend('limit')
  limit.limit = 100

  function limit:__tostring()
    return 'limit account '..self.balance..' of '..self.limit
  end
  limit._deposit = limit.deposit
  function limit:deposit(v)
    self:_deposit(v)
    if self.balance > self.limit then
      self.balance = self.limit
    end
  end

  local masha = account:create({})
  masha:deposit(30)
  ass(tostring(masha) == 'account 30')

  local kolya = limit:create({})
  kolya:deposit(120)
  ass(tostring(kolya) == 'limit account 100 of 100')

  ass(getmetatable(account) == object)
  ass(getmetatable(masha) == account)
  ass(getmetatable(limit) == account)
  ass(getmetatable(kolya) == limit)
end

return object