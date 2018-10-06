local MoveDiagonal = require 'src.battle.powers.MoveDiagonal'
local Multiply     = require 'src.battle.powers.Multiply'
local Rehash       = require 'src.battle.powers.Rehash'
local Relocate     = require 'src.battle.powers.Relocate'
local Recruit      = require 'src.battle.powers.Recruit'
local Swap         = require 'src.battle.powers.Swap'
local Zones        = require 'src.battle.zones.Zones'

local Powers = {MoveDiagonal, Multiply, Rehash, Relocate, Recruit, Swap}

-- Ability has a potential to become certain power.
local Ability = {typename="Ability"}
Ability.__index = Ability

-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
function Ability:__tostring() 
  local name = self.Power.typename
  if self.Zone then
    name = name.. " ".. self.Zone.typename
  end
  return name
end
-------------------------------------------------------------------------------
function Ability:increase()
  self.count = self.count + 1
end
-------------------------------------------------------------------------------
function Ability:decrease()
  self.count = self.count - 1
  if self.count == 0 then
    return nil
  end
  return self
end
-------------------------------------------------------------------------------
function Ability:get_count()
  return self.count
end
-------------------------------------------------------------------------------
function Ability:create_power()
  return self.Power.new(self.Zone)
end

return Ability