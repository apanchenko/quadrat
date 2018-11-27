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
-------------------------------------------------------------------------------
function Teach:apply(piece)
  local space = piece.space
  local zone = self.Zone.New(piece.pos)

  -- select cells in zone
  local cells = space:select_cells(function(c) return zone:filter(c.pos) and not zone.pos==c.pos end)
  for i = 1, #cells do
    -- friend piece
    local p = cells[i].piece
    if p and p.color == piece.color then
      -- learn my abilities
      for name, ability in piece.abilities:pairs() do
        p.abilities:learn(ability)
      end --abilities
    end --p
  end --cells
  return nil
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Teach, 'apply', 'Piece')
log:wrap(Teach, 'apply')
return Teach