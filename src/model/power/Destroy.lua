local vec       = require "src.core.vec"
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local object    = require 'src.core.object'
local col       = require 'src.model.zones.Col'

local Destroy = object:new({name = 'Destroy', is_areal = true})

function Destroy:create(zone)
  local t = setmetatable({zone = zone}, self)
  self.__index = self
  return t
end

-- POWER ----------------------------------------------------------------------
--
function Destroy:apply(piece)
  local zone = self.zone.New(piece.pos)

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
  return tostring(Destroy).. ' '.. tostring(self.zone)
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Destroy, ':apply', 'Piece')

log:wrap(Destroy, 'apply')

function Destroy.test()
  log:trace('Destroy:test')

  local destroy = Destroy(col)

  ass(tostring(destroy) == 'Destroy Col')
end

return Destroy