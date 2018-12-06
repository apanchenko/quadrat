local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local cfg       = require "src.Config"
local Color     = require 'src.model.Color'

local Destroy = Class.Create('Destroy', {is_areal = true})

function Destroy.New(Zone)
  ass(Zone)
  local self = setmetatable({}, Destroy)
  self.Zone = Zone
  return self
end

-- POWER ----------------------------------------------------------------------
--
function Destroy:apply(piece)
  local zone = self.Zone.New(piece.pos)

  -- select cells in zone
  local spots = piece.space:select_spots(function(spot)
    return zone:filter(spot.pos) and zone.pos ~= spot.pos and spot.piece and spot.piece.color ~= piece.color
  end)

  for i = 1, #spots do
    local spot = spots[i]
    spot.piece.die() -- enemy piece
    spot.piece = nil
    piece.space:notify('remove_piece', spot.pos) -- notify
  end
end

--
function Destroy:__tostring()
  return tostring(Destroy).. tostring(self.Zone)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Destroy, ':apply', 'Piece')

log:wrap(Destroy, 'apply')

return Destroy