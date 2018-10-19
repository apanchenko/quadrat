local vec       = require "src.core.vec"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local Zones     = require 'src.battle.zones.Zones'
local Color     = require 'src.model.Color'
local log       = require 'src.core.log'

local Swap =
{
  typename = "Swap",
  is_areal = true
}
Swap.__index = Swap

-------------------------------------------------------------------------------
function Swap.new(Zone)
  assert(Zone)
  local self = setmetatable({}, Swap)
  self.Zone = Zone
  return self
end
-------------------------------------------------------------------------------
function Swap:apply(piece)
  local depth = log:trace(self, ":apply"):enter()
    local board = piece.board
    local zone = self.Zone.new(piece:get_pos())
    local cells = board:select_cells(function(cell) return zone:filter(cell) end)
    for i = 1, #cells do
      local p = cells[i].piece
      if p then
        p:set_color(Color.swap(p.color))
      end
    end
  log:exit(depth)
  return nil
end
-------------------------------------------------------------------------------
function Swap:__tostring()
  return Swap.typename.. self.Zone.typename
end

return Swap