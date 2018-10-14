local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local Zones     = require 'src.battle.zones.Zones'
local Color     = require 'src.battle.Color'
local log       = require 'src.core.log'

local Teach =
{
  typename = "Teach",
  is_areal = true
}
Teach.__index = Teach

-------------------------------------------------------------------------------
function Teach.new(Zone)
  assert(Zone)
  local self = setmetatable({}, Teach)
  self.Zone = Zone
  return self
end
-------------------------------------------------------------------------------
function Teach:apply(piece)
  local depth = log:trace(self, ":apply"):enter()
    local board = piece.board
    local zone = self.Zone.new(piece.pos)

    -- select cells in zone
    local cells = board:select_cells(function(c) return zone:filter(c) and not zone.pos:equals(c.pos) end)
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
  log:exit(depth)
  return nil
end
-------------------------------------------------------------------------------
function Teach:__tostring()
  return Teach.typename.. self.Zone.typename
end

return Teach