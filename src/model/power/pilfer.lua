local ass       = require 'src.core.ass'
local wrp     = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local pilfer = areal:extend('Pilfer')

-- can spawn in jade
function pilfer:can_spawn()
  return true
end

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function pilfer:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid ~= self.piece.pid then
    --for id, jade in piece.jades:pairs() do
    piece.jades:each(function(jade, id)
      local removed = piece:remove_jade(id, jade.count) -- consume all
      self.piece:add_jade(removed)
    end)
  end
end

--
function pilfer:wrap()
  wrp.wrap_sub_trc(pilfer, 'apply_to_spot', {'spot'})
end

return pilfer