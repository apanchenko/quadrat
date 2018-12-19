local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local power   = require 'src.model.power.power'

-- power with counter
local counted = power:extend('counted')

-- constructor
-- @param piece - apply power to this piece
function counted:new(piece)
  self = power.new(self, piece)
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
ass.wrap(counted, ':new', 'Piece')
ass.wrap(counted, ':apply')
ass.wrap(counted, ':increase')
ass.wrap(counted, ':decrease')
ass.wrap(counted, ':get_count')

log:wrap(counted, 'new', 'apply', 'increase', 'decrease')

return counted