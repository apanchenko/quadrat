local powers       = require 'src.model.power.powers'
local Zones        = require 'src.model.zones.Zones'
local ass          = require 'src.core.ass'
local obj          = require 'src.core.obj'
local typ          = require 'src.core.typ'
local log          = require 'src.core.log'
local arr          = require 'src.core.arr'
local wrp          = require 'src.core.wrp'

-- Ability has a potential to become certain power.
local Ability = obj:extend('Ability')

-- create ability with random power
function Ability:new()
  self = obj.new(self,
  {
    Power = arr.random(powers),
    count = 1
  })

  self.id = tostring(self.Power)

  if self.Power.is_areal then
    self.Zone = arr.random(Zones)
    self.id = self.id.. ' '.. tostring(self.Zone)
  end

  return self
end

--
function Ability:__tostring() 
  local name = tostring(self.Power)
  if self.Zone then
    name = name.. ' '.. tostring(self.Zone)
  end
  return name
end
--
function Ability:get_id()     return self.id end
--
function Ability:get_count()  return self.count end

-- increase ability count
function Ability:add_to(abilities)
  local other = abilities[self.id]
  if other then
    ass.eq(other.id, self.id)
    other.count = other.count + self.count
  else
    abilities[self.id] = self
  end
  return self.count
end

-- decrease ability count, chained
function Ability:decrease(abilities, count)
  ass.eq(self, abilities[self.id])
  ass.le(count, self.count)
  if count == self.count then
    abilities[self.id] = nil
    return 0
  end
  self.count = self.count - count
  return self.count
end

--
function Ability:create_power(piece)
  local power = self.Power:new(piece, self.Zone)
  return power:apply()
end


-- MODULE ---------------------------------------------------------------------
function Ability.wrap()
  wrp.fn(Ability, 'new', {})
  wrp.fn(Ability, 'add_to', {{'abilities', typ.tab}})
  wrp.fn(Ability, 'decrease', {{'abilities', typ.tab}, {'count', typ.num}})
  wrp.fn(Ability, 'create_power', {{'Piece'}})
end

return Ability