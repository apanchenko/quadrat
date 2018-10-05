local vec = require "src.core.vec"
local lay = require "src.core.lay"
local cfg = require "src.Config"
local Zones = require 'src.battle.zones.Zones'

local Recruit =
{
  typename = "Recruit",
  is_areal = true
}
Recruit.__index = Recruit

-------------------------------------------------------------------------------
function Recruit.new(Zone)
  assert(Zone)
  local self = setmetatable({}, Recruit)
  self.Zone = Zone
  return self
end
-------------------------------------------------------------------------------
function Recruit:apply(piece)
  local log = piece.log
  log:trace(self, ":apply"):enter()
    local board = piece.board
    local zone = self.Zone.new(piece.pos)
    local cells = board:select_cells(function(cell) return zone:filter(cell) end)
    for i = 1, #cells do
      local p = cells[i].piece
      if p then
        p:set_color(piece.color)
      end
    end
  log:exit()
  return nil
end
-------------------------------------------------------------------------------
function Recruit:__tostring()
  return "Recruit ".. self.Zone.typename
end

return Recruit