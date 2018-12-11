local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local types     = require 'src.core.types'
local object    = require 'src.core.object'

-- areal power
local areal = object:extend('areal')
areal.is_areal = true

-- create an areal power that sits on onwer piece and acts once or more times
-- @param space - world
-- @param piece - apply power to this piece
-- @param zone - area power applyed to
local _create = object.create
function areal:create(space, owner, zone)
  return _create(self, {space=space, owner=owner, zone=zone})
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
ass.wrap(areal, ':create', 'Space', 'Piece', types.tab)
ass.wrap(areal, ':apply')
log:wrap(areal, 'apply')

return areal