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
  local board = piece.board
  local zone = self.Zone.New(piece.pos)

  -- select cells in zone
  local cells = board:select_cells(function(c) return zone:filter(c.pos) and zone.pos~=c.pos end)
  for i = 1, #cells do
    -- enemy piece
    local p = cells[i].piece
    if p and p.color ~= piece.color then
      p:putoff()
    end
  end
  return nil
end

--
function Destroy:__tostring()
  return tostring(Destroy).. tostring(self.Zone)
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Destroy, 'apply', 'Piece')

log:wrap(Destroy, 'apply')

return Destroy