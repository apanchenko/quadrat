local ass       = require 'src.core.ass'
local areal     = require 'src.model.power.areal'
local Color     = require 'src.model.Color'

local teach = areal:extend('Teach')

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function teach:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.color == self.piece.color then
    for name, ability in pairs(self.piece.abilities) do
      piece:learn_ability(ability)
    end --abilities
  end
end

--
ass.wrap(teach, ':apply_to_spot', 'Spot')

return teach