local ass       = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local pilfer = areal:extend('Pilfer')

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function pilfer:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid ~= self.piece.pid then
    for id, jade in pairs(piece.jades) do
      local removed = piece:remove_jade(id, jade.count) -- consume all
      self.piece:add_jade(removed)
    end
  end
end

--
function pilfer.wrap()
  wrp.fn(pilfer, 'apply_to_spot', {{'Spot'}})
end

return pilfer