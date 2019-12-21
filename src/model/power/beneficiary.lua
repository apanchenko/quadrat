local ass       = require 'src.lua-cor.ass'
local arr       = require 'src.lua-cor.arr'
local typ       = require('src.lua-cor.typ')
local wrp       = require('src.lua-cor.wrp')
local power     = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('mode')

local beneficiary = power:extend('Beneficiary')

-- can spawn in jade
function beneficiary:can_spawn()
  return true
end

--
function beneficiary:new(piece, world, def)
  -- select friend spots in area
  local pid = piece:get_pid()
  local spots = world:select_spots(function(spot)
    local spot_piece = spot.piece
    return spot_piece and spot_piece ~= piece and spot_piece:get_pid() == pid
  end)

  -- apply to each selected spot
  spots:each(function(spot)
    spot.piece:each_jade(function(jade)
      piece:add_jade(jade)
    end)
    spot.piece:clear_jades()
  end)
  -- return nothing
end

--
function beneficiary:wrap()
  local piece = require('src.model.piece.piece')
  local World = require('src.model.space.space')
  wrp.fn(log.trace, beneficiary, 'new', beneficiary, piece, typ.ext(World), typ.tab)
end

return beneficiary