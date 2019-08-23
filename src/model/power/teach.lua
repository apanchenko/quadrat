local areal     = require 'src.model.power.areal'
local log = require('src.lua-cor.log').get('mode')

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
    self.piece.jades_cnt:each(function(jade)
      piece:add_jade(jade)
    end)
  end
end

--
function teach:wrap()
  local wrp     = require 'src.lua-cor.wrp'
  local typ     = require 'src.lua-cor.typ'
  local ex   = typ.new_ex(teach)

  wrp.fn(log.trace, teach, 'apply_to_spot', ex, 'spot')
end

return teach