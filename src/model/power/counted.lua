local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local typ     = require 'src.core.typ'
local wrp     = require 'src.core.wrp'
local power   = require 'src.model.power.power'

-- power with counter
local counted = power:extend('counted')

-- constructor
-- @param piece - apply power to this piece
function counted:new(piece, id)
  self = power.new(self, piece, id)
  self.count = 1
  return self
end

--
--function counted:__tostring()
--  return power.__tostring(self).. "[".. self.count.. "]"
--end

-- use
function counted:apply()
  return self
end
--
function counted:increase()
  self.count = self.count + 1
end
--
function counted:decrease()
  self.count = self.count - 1
  if self.count > 0 then
    return self
  end
end
--
function counted:get_count()
  return self.count
end

--
function counted:wrap()
  wrp.fn(counted, 'new',        {{'Piece'}, {'id', typ.str}})
  wrp.fn(counted, 'apply')
  wrp.fn(counted, 'increase')
  wrp.fn(counted, 'decrease')
  wrp.fn(counted, 'get_count',  {}, {log=log.info})
end

return counted