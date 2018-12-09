local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local types     = require 'src.core.types'

local function areal(space, owner, zone)
  ass.is(space, 'Space')
  ass.is(owner, 'Piece')
  ass.is(zone, types.tab)

  local self = {}

  -- use and consume power
  self.apply = function()
    -- specify spell area rooted from piece
    local area = zone.New(owner.pos)
    -- select spots in area
    local spots = space:select_spots(function(spot) return area:filter(spot.pos) end)
    -- apply to each selected spot
    for i = 1, #spots do
      self.apply_to_spot(spots[i])
    end
  end

  return self
end
  
--[[
-- areal power
local areal = object:new({name = 'areal', is_areal = true})

-- create an areal power that sits on onwer piece and acts once or more times
-- @param space - world
-- @param piece - apply power to this piece
-- @param zone - area power applyed to
areal._new = areal.new
function areal:new(space, owner, zone)
  --self.space = space
  --self.owner = owner
  --self.zone = zone
  return areal:_new({space=space, owner=owner, zone=zone})
end

-- use and consume power
function areal:apply()
  -- specify spell area rooted from piece
  local area = self.zone.New(self.owner.pos)
  -- select spots in area
  local spots = self.space:select_spots(function(spot) return area:filter(spot.pos) end)
  -- apply to each selected spot
  for i = 1, #spots do
    self:apply_to_spot(spots[i])
  end
end

--
function areal:__tostring()
  return 'areal'..tostring(self.owner.pos)
end

--
ass.wrap(areal, ':new', 'Space', 'Piece', types.tab)
--ass.wrap(areal, ':areal_init', 'Space', 'Piece', types.tab)
ass.wrap(areal, ':apply')
--log:wrap(areal, 'areal_init', 'apply')
--]]
return areal