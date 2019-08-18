local ass       = require 'src.lua-cor.ass'
local wrp     = require 'src.lua-cor.wrp'
local areal     = require 'src.model.power.areal'
local typ         = require 'src.lua-cor.typ'
local log = require('src.lua-cor.log').get('mode')

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
    --for id, jade in piece.jades_cnt:pairs() do
    piece:each_jade(function(jade, id)
      local removed = piece:remove_jade(id, jade.count) -- consume all
      self.piece:add_jade(removed)
    end)
  end
end

--
function pilfer:wrap()
  local ex    = {'expilfer', typ.new_ex(pilfer)}
  wrp.fn(log.trace, pilfer, 'apply_to_spot', ex, {'spot'})
end

return pilfer