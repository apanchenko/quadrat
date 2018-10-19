local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local Zones     = require 'src.battle.zones.Zones'
local Color     = require 'src.model.Color'
local log       = require 'src.core.log'

local Destroy =
{
  typename = "Destroy",
  is_areal = true
}
Destroy.__index = Destroy

-------------------------------------------------------------------------------
function Destroy.new(Zone)
  assert(Zone)
  local self = setmetatable({}, Destroy)
  self.Zone = Zone
  return self
end
-------------------------------------------------------------------------------
function Destroy:apply(piece)
  local depth = log:trace(self, ":apply"):enter()
    local board = piece.board
    local zone = self.Zone.new(piece:get_pos())

    -- select cells in zone
    local cells = board:select_cells(function(c) return zone:filter(c) and zone.pos~=c.pos end)
    for i = 1, #cells do
      -- enemy piece
      local p = cells[i].piece
      if p and p.color ~= piece.color then
        p:putoff()
      end
    end
  log:exit(depth)
  return nil
end
-------------------------------------------------------------------------------
function Destroy:__tostring()
  return Destroy.typename.. self.Zone.typename
end

return Destroy