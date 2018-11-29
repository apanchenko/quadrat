local vec       = require "src.core.Vec"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local Zones     = require 'src.model.zones.Zones'
local Color     = require 'src.model.Color'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Type      = require 'src.core.Type'

local Destroy = Type.Create('Destroy', {is_areal = true})

function Destroy.New(Zone)
  Ass(Zone)
  local self = setmetatable({}, Destroy)
  self.Zone = Zone
  return self
end

-- POWER ----------------------------------------------------------------------
--
function Destroy:apply(piece)
  local space = piece.space
  local zone = self.Zone.New(piece.pos)

  -- select cells in zone
  local spots = space:select_spots(function(spot) return zone:filter(spot.pos) and zone.pos ~= spot.pos end)
  for i = 1, #spots do
    -- enemy piece
    local spot = spots[i]
    if spot.piece and spot.piece.color ~= piece.color then
      spot.piece.die()
      spot.piece = nil
      space:notify('remove_piece', spot.pos) -- notify
    end
  end
end

--
function Destroy:__tostring()
  return tostring(Destroy).. tostring(self.Zone)
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Destroy, 'apply', 'Piece')

log:wrap(Destroy, 'apply')

return Destroy