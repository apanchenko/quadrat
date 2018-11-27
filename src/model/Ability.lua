local Powers       = require 'src.model.powers.Powers'
local Zones        = require 'src.model.zones.Zones'
local Ass          = require 'src.core.Ass'
local Type         = require 'src.core.Type'

-- Ability has a potential to become certain power.
local Ability = Type.Create('Ability')

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
function Ability:get_count()
  return self.count
end

--
function Ability:create_power()
  return self.Power.New(self.Zone)
end

return Ability