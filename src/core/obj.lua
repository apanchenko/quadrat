local ass   = require 'src.core.ass'
local log   = require 'src.core.log'
local typ   = require 'src.core.typ'

-------------------------------------------------------------------------------
local obj = setmetatable({}, {__tostring = function() return 'obj' end})

--
function obj.__call(cls, ...)
  return cls:new(...)
end
--
function obj:__tostring()
  return self._typename
end
--
function obj:extend(typename)
  local sub = setmetatable({_typename=typename}, self)
  self.__index = self
  function sub:__tostring() return self._typename end
  return sub
end
--
function obj:new(def)
  def = setmetatable(def or {}, self)
  self.__index = self
  return def
end

-- selftest -------------------------------------------------------------------
ass.wrap(obj, ':extend', typ.str)
--ass.wrap(obj, ':new')

--
function obj.test()
  ass(tostring(obj))

  -- account extends obj
  local account = obj:extend('account')
  -- add balance property to account
  account.balance = 0
  -- account instance to string
  function account:__tostring()     return 'account '..self.balance end
  -- add function deposit to account
  function account:deposit(v)       self.balance = self.balance + v end

  ass.eq(tostring(account), 'account')

  -- extended type of account
  local limited = account:extend('limited')
  -- add limit property
  limited.limit = 100
  -- limited account instance tostring
  function limited:__tostring()     return 'limited account '..self.balance..' of '..self.limit end
  -- overload deposit method
  limited._deposit = limited.deposit
  function limited:deposit(v)       self:_deposit(math.min(v, self.limit)) end

  -- masha's account
  local masha = account:new()
  masha:deposit(30)
  ass(tostring(masha) == 'account 30')

  -- kolya's limited account
  local kolya = limited:new()
  kolya:deposit(120)
  ass(tostring(kolya) == 'limited account 100 of 100')

  ass.is(account, obj)
  ass.is(masha, account)
  ass.is(limited, account)
  ass.is(kolya, limited)
end

return obj