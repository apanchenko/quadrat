--[[
    Inheritance implementation. The obj is a base type you may extend from.
    Call 'extend' to inherit new type and 'new' to create instance of a type.

    While there is no semantic difference between type and instance in Lua
    and so it is not a problem to inherit any table, classic OOP does not
    defines this. Should we prohibit extending instance objects?
]]--

-- Create obj
local mt        = {__tostring = function(self) return self.tname end}
local obj       = setmetatable({tname = 'obj'}, mt)
obj.__index     = obj

-- Create library table for static functions
obj.create_lib = function(tname)
  local lib = setmetatable({tname = tname}, mt)
  lib.__index = lib 
  return lib
end 

-- Create new type extending obj
obj.extend = function(self, tname)
  local sub = setmetatable({tname = tname}, self)
  sub.__index = sub
  sub.__tostring = function(self) return self.tname end
  return sub
end

-- Construct instance object
obj.new = function(self, def) return setmetatable(def or {}, self) end

-- Helper for faster call new
obj.__call = function(t, ...) return t:new(...) end

-- Support tostring for ancestors
obj.__tostring  = function(self) return self.tname end


-- module -------------------------------------------------------------------
--
function obj:wrap()
  local wrp   = require 'src.core.wrp'
  local typ   = require 'src.core.typ'
  local ass   = require 'src.core.ass'
  ass.eq(tostring(obj), 'obj')
  wrp.wrap_tbl_inf(obj, 'extend', {'name', typ.str})
  --wrp.wrap_tbl_inf(obj, 'new',    {{'def', typ.any}})
end

--
function obj:test(ass) 
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