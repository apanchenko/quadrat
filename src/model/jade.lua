local ass     = require 'src.core.ass'
local log     = require 'src.core.log'
local vec     = require 'src.core.vec'
local obj     = require 'src.core.obj'
local wrp     = require 'src.core.wrp'
local typ     = require 'src.core.typ'
local powers  = require 'src.model.power.package'
local zones   = require 'src.model.zones.package'

-- jade
local jade = obj:extend('jade')

-- construct random jade
function jade:new()
  ass.eq(self, jade)
  self = obj.new(self)
  self.power = powers:random(function(p) return p:can_spawn() end)
  ass(self.power)
  self.id = self.power.type
  self.count = 1

  if self.power.is_areal then
    self.zone = zones:random()
    self.id = self.id.. ' '.. self.zone.type
  end
  return self
end

--
function jade:__tostring()
  return self.type.. '{'.. self.id.. '}'
end

--
function jade:set_pos(pos)
  -- skip
end

-- construct another identical jade
function jade:copy()
  return obj.new(jade, {
    power = self.power,
    zone = self.zone,
    id = self.id,
    count = self.count
  })
end

-- add this jade to map id->jade
function jade:add_to(jades)
  local other = jades[self.id]
  if other then
    other.count = other.count + self.count
    return other.count
  end

  jades[self.id] = self
  return self.count
end

-- divide jade into two jades buy count
-- set this jade count, return what is left (or nil)
function jade:split(count)
  ass.le(count, self.count)
  if count == self.count then
    return nil
  end
  local remaining = self:copy()
  remaining.count = self.count - count
  self.count = count
  return remaining
end

-- produce power from this jade
-- normally jade shoud be destroyed after this
function jade:use(piece)
  return self.power:new(piece, {}, self.zone)
end

-- module
function jade:wrap()
  wrp.wrap_tbl_inf(jade, 'new')
  wrp.wrap_sub_trc(jade, 'add_to', {'jades', typ.tab})
  wrp.wrap_sub_trc(jade, 'use',    {'piece'})
  --wrp.fn(jade, 'set_pos', {{'pos', vec}})
end

return jade