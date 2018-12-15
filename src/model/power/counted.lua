local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local power   = require 'src.model.power.power'

-- power with counter
local counted = power:extend('counted')

-- constructor
-- @param piece - apply power to this piece
local power_create = power.create
function counted:create(piece)
  local instance = power_create(self, piece)
  instance.count = 1
  return instance
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
ass.wrap(counted, ':create', 'Piece')
ass.wrap(counted, ':apply')
ass.wrap(counted, ':increase')
ass.wrap(counted, ':decrease')
ass.wrap(counted, ':get_count')

log:wrap(counted, 'create', 'apply', 'increase', 'decrease')

return counted