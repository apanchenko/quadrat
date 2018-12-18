local powers       = require 'src.model.power.powers'
local Zones        = require 'src.model.zones.Zones'
local ass          = require 'src.core.ass'
local obj          = require 'src.core.obj'
local typ          = require 'src.core.typ'
local log          = require 'src.core.log'
local arr          = require 'src.core.arr'

-- Ability has a potential to become certain power.
local Ability = obj:extend('Ability')

-- create ability with random power
local obj_create = obj.create
function Ability:create()
  local this = obj_create(self)
  this.Power = arr.random(powers)

  if this.Power.is_areal then
    this.Zone = arr.random(Zones)
  end

  this.count = 1
  return this
end

--
function Ability:__tostring() 
  local name = tostring(self.Power)
  if self.Zone then
    name = name.. ' '.. tostring(self.Zone)
  end
  return name
end

-- increase ability count
function Ability:increase(count)
  ass.natural(count, tostring(count))
  self.count = self.count + count
end

-- decrease ability count, chained
function Ability:decrease()
  self.count = self.count - 1
  if self.count == 0 then
    return nil
  end
  return self
end

--
function Ability:create_power(piece)
  local power = self.Power:create(piece, self.Zone)
  return power:apply()
end


-- MODULE ---------------------------------------------------------------------
ass.wrap(Ability, ':create')
ass.wrap(Ability, ':increase', typ.num)
ass.wrap(Ability, ':decrease')
ass.wrap(Ability, ':create_power', 'Piece')

log:wrap(Ability)

return Ability