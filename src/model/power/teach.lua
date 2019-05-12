local ass       = require 'src.luacor.ass'
local wrp     = require 'src.luacor.wrp'
local areal     = require 'src.model.power.areal'

local teach = areal:extend('Teach')

-- can spawn in jade
function teach:can_spawn()
  return true
end

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function teach:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid == self.piece.pid then
    self.piece.jades:each(function(jade)
      piece:add_jade(jade)
    end)
  end
end

--
function teach:wrap()
  wrp.wrap_sub_trc(teach, 'apply_to_spot', {'spot'})
end

return teach