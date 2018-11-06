local MoveDiagonal = require 'src.model.powers.MoveDiagonal'
local Multiply     = require 'src.model.powers.Multiply'
local Rehash       = require 'src.model.powers.Rehash'
local Relocate     = require 'src.model.powers.Relocate'
local Recruit      = require 'src.model.powers.Recruit'
local Swap         = require 'src.model.powers.Swap'
local Sphere       = require 'src.model.powers.Sphere'
local Impeccable   = require 'src.model.powers.Impeccable'
local Teach        = require 'src.model.powers.Teach'
local Destroy      = require 'src.model.powers.Destroy'
local Zones        = require 'src.model.zones.Zones'
local ass          = require 'src.core.ass'

local Powers =
{
  MoveDiagonal, Multiply, Rehash, Relocate, Recruit, Swap, Sphere,
  Impeccable, Teach, Destroy
}

-- Ability has a potential to become certain power.
local Ability = setmetatable({}, { __tostring = function() return 'Ability' end })
Ability.__index = Ability

-- create ability with random power
function Ability.new()
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
  local name = self.Power.typename
  if self.Zone then
    name = name.. " ".. self.Zone.typename
  end
  return name
end

-- increase ability count
function Ability:increase(count)
  ass.Natural(count, tostring(count))
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
  return self.Power.new(self.Zone)
end

return Ability