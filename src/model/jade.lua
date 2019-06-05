local ass     = require 'src.lua-cor.ass'
local log     = require('src.lua-cor.log').get('mode')
local vec     = require 'src.lua-cor.vec'
local obj     = require 'src.lua-cor.obj'
local wrp     = require 'src.lua-cor.wrp'
local typ     = require 'src.lua-cor.typ'
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
  self.id = tostring(self.power)
  self.count = 1

  if self.power.is_areal then
    self.zone = zones:random()
    self.id = self.id.. ' '.. tostring(self.zone)
  end
  return self
end

--
function jade:__tostring()
  return self:get_typename().. '{'.. self.id.. '}'
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
  wrp.wrap_tbl(log.info, jade, 'new')
  wrp.wrap_sub(log.trace, jade, 'add_to', {'jades', typ.tab})
  wrp.wrap_sub(log.trace, jade, 'use',    {'piece'})
  --wrp.fn(jade, 'set_pos', {{'pos', vec}})
end

return jade