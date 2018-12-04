local Powers       = require 'src.model.powers.Powers'
local Zones        = require 'src.model.zones.Zones'
local Ass          = require 'src.core.Ass'
local Class        = require 'src.core.Class'
local types        = require 'src.core.types'
local log          = require 'src.core.log'

-- Ability has a potential to become certain power.
local Ability = Class.Create 'Ability'

-- create ability with random power
function Ability.New()
  local self = setmetatable({}, Ability)
  self.Power = Powers[math.random(#Powers)]

  if self.Power.is_areal then
    self.Zone = Zones[math.random(#Zones)]
  end

  self.count = 1
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

-- increase ability count
function Ability:increase(count)
  Ass.Natural(count, tostring(count))
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
  local power = self.Power.New(self.Zone)
  return power:apply(piece)
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Ability, '.New')
Ass.Wrap(Ability, ':increase', types.Num)
Ass.Wrap(Ability, ':decrease')
Ass.Wrap(Ability, ':create_power', 'Piece')

log:wrap(Ability)

return Ability