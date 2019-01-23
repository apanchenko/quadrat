local ass       = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local teach = areal:extend('Teach')

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function teach:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid == self.piece.pid then
    for name, ability in pairs(self.piece.abilities) do
      piece:learn_ability(ability)
    end --abilities
  end
end

--
function teach.wrap()
  wrp.fn(teach, 'apply_to_spot', {{'Spot'}})
end

return teach