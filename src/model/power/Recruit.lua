local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local types     = require 'src.core.types'
local cfg       = require 'src.Config'
local Color     = require 'src.model.Color'

-------------------------------------------------------------------------------
local Recruit = Class.Create('Recruit', {is_areal = true})
--
function Recruit.New(Zone)
  assert(Zone)
  local self = setmetatable({}, Recruit)
  self.Zone = Zone
  return self
end
--
function Recruit:__tostring()
  return tostring(Recruit)..' '..tostring(self.Zone)
end

-- POWER ----------------------------------------------------------------------
--
function Recruit:apply(piece)
  local zone = self.Zone.New(piece.pos)
  local spots = piece.space:select_spots(function(spot) return zone:filter(spot.pos) and spot.piece end)
  for i = 1, #spots do
    spots[i].piece:set_color(piece.color)
  end
  return nil
end

-- MODULE ---------------------------------------------------------------------
--ass.wrap(Multiply, 'New', )
ass.wrap(Recruit, ':apply', 'Piece')

log:wrap(Recruit, 'apply')

return Recruit