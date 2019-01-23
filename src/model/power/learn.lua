local ass       = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local learn = areal:extend('Learn')

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function learn:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid == self.piece.pid then
    for name, ability in pairs(piece.abilities) do
      self.piece:learn_ability(ability)
    end --abilities
  end
end

--
function learn.wrap()
  wrp.fn(learn, 'apply_to_spot', {{'Spot'}})
end

return learn