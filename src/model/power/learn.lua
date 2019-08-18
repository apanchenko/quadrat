local ass       = require 'src.lua-cor.ass'
local wrp       = require 'src.lua-cor.wrp'
local typ         = require 'src.lua-cor.typ'
local areal     = require 'src.model.power.areal'
local log = require('src.lua-cor.log').get('mode')

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
    piece.jades_cnt:each(function(jade)
      self.piece:add_jade(jade:copy())
    end)
  end
end

--
function learn:wrap()
  local ex    = {'exlearn', typ.new_ex(learn)}
  wrp.fn(log.trace, learn, 'apply_to_spot', ex, {'spot'})
end

return learn