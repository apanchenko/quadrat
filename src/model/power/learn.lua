local ass       = require 'src.lua-cor.ass'
local wrp       = require 'src.lua-cor.wrp'
local areal     = require 'src.model.power.areal'

local learn = areal:extend('Learn')

-- can spawn in jade
function learn:can_spawn()
  return true
end

-- implement pure virtual areal:apply_to_spot
-- teach other pieces in zone
function learn:apply_to_spot(spot)
  local piece = spot.piece
  if piece and piece.pos ~= self.piece.pos and piece.pid == self.piece.pid then
    piece.jades:each(function(jade)
      self.piece:add_jade(jade:copy())
    end)
  end
end

--
function learn:wrap()
  wrp.wrap_sub_trc(learn, 'apply_to_spot', {'spot'})
end

return learn