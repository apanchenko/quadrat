local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local typ     = require 'src.core.typ'
local power     = require 'src.model.power.power'

-- areal power
local areal = power:extend('areal')
areal.is_areal = true

-- create an areal power that sits on onwer piece and acts once or more times
-- @param piece - apply power to this piece
-- @param zone - area power applyed to
local power_create = power.create
function areal:create(piece, zone)
  local a = power_create(self, piece)
  a.zone = zone
  return a
end

-- use and consume power
function areal:apply()
  -- specify spell area rooted from piece
  local area = self.zone.New(self.piece.pos)
  -- select spots in area
  local spots = self.piece.space:select_spots(function(spot) return area:filter(spot.pos) end)
  -- apply to each selected spot
  for i = 1, #spots do
    self:apply_to_spot(spots[i])
  end
end

--
ass.wrap(areal, ':create', 'Piece', typ.tab)
ass.wrap(areal, ':apply')
log:wrap(areal, 'apply')

return areal