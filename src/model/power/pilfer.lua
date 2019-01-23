local ass       = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local pilfer = areal:extend('Pilfer')

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function pilfer:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid ~= self.piece.pid then
    for id, abty in pairs(piece.abilities) do
      piece:consume_ability(id, abty:get_count()) -- consume all
      self.piece:learn_ability(abty)
    end --abilities
  end
end

--
function pilfer.wrap()
  wrp.fn(pilfer, 'apply_to_spot', {{'Spot'}})
end

return pilfer