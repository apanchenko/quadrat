local vec       = require "src.core.Vec"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local Zones     = require 'src.model.zones.Zones'
local Color     = require 'src.model.Color'
local log       = require 'src.core.log'
local Ass       = require 'src.core.Ass'
local Type      = require 'src.core.Type'

local Teach = Type.Create('Teach', {is_areal = true})

-------------------------------------------------------------------------------
function Teach.New(Zone)
  assert(Zone)
  local self = setmetatable({}, Teach)
  self.Zone = Zone
  return self
end
-------------------------------------------------------------------------------
function Teach:__tostring()
  return tostring(Teach).. tostring(self.Zone)
end
--
function Teach:apply(piece)
  local zone = self.Zone.New(piece.pos)

  -- select cells in zone
  local spots = piece.space:select_spots(function(spot)
    return zone:filter(spot.pos) and spot.pos ~= zone.pos and spot.piece and spot.piece.color == piece.color
  end)

  for i = 1, #spots do
    local spot = spots[i]
    -- learn my abilities
    for name, ability in pairs(piece.abilities) do
      spot.piece:learn_ability(ability)
    end --abilities
  end --cells
  return nil
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Teach, 'apply', 'Piece')
log:wrap(Teach, 'apply')
return Teach