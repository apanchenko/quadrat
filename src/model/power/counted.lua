local log     = require('src.lua-cor.log').get('mode')
local power   = require 'src.model.power.power'

-- power with counter
local counted = power:extend('counted')

-- constructor
-- @param piece - apply power to this piece
function counted:new(piece, def)
  def.count = 1
  return power.new(self, piece, def)
end

-- add to powers map
function counted:add_to(powers)
  local other = powers[self.id]
  if other then
    other.count = other.count + self.count
    return other.count
  end

  powers[self.id] = self
  return self.count
end

--
--function counted:__tostring()
--  return power.__tostring(self).. "[".. self.count.. "]"
--end

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
  local piece = require('src.model.piece.piece')
  local typ  = require('src.lua-cor.typ')
  local wrp  = require('src.lua-cor.wrp')
  local ex   = typ.new_ex(counted)

  wrp.fn(log.trace, counted, 'new',        counted, piece, typ.tab)
  wrp.fn(log.trace, counted, 'increase',   ex)
  wrp.fn(log.trace, counted, 'decrease',   ex)
  wrp.fn(log.info, counted, 'get_count',   ex)
end

return counted