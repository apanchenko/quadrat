local power = require('src.model.power.power')
local ass   = require('src.lua-cor.ass')
local arr   = require('src.lua-cor.arr')

local rehash = power:extend('Rehash')

-- can spawn in jade
function rehash:can_spawn()
  return true
end

-- use
function rehash:new(piece, world)
  local jades = arr()
  local spots = arr()

  -- gather jades and free spots
  world:each_spot(function(spot)
    if spot.jade then
      spot:stash_jade(jades)
      ass(spot:can_set_jade()) -- jade just removed, should be able to set it back
    end
    if spot:can_set_jade() then
      spots:push(spot)
    end
  end)
  ass.le(#jades, #spots)

  -- randomize jades over spots gathered
  while not jades:is_empty() do
    local spot = spots:remove_random()
    spot:unstash_jade(jades)
  end
end

-- MODULE ---------------------------------------------------------------------
function rehash:wrap()
  local wrp   = require('src.lua-cor.wrp')
  local typ   = require('src.lua-cor.typ')
  local log   = require('src.lua-cor.log').get('mode')
  local piece = require('src.model.piece.piece')
  local World = require('src.model.space.space')
  wrp.fn(log.trace, rehash, 'new',       rehash, piece, typ.ext(World), typ.tab)
  wrp.fn(log.info, rehash, 'can_spawn', rehash)
end

return rehash