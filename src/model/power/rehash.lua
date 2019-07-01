local power = require 'src.model.power.power'
local ass   = require 'src.lua-cor.ass'
local arr   = require 'src.lua-cor.arr'
local wrp   = require 'src.lua-cor.wrp'
local typ   = require 'src.lua-cor.typ'
local log   = require('src.lua-cor.log').get('mode')

local rehash = power:extend('Rehash')

-- can spawn in jade
function rehash:can_spawn()
  return true
end

-- use
function rehash:new(piece)
  local jades = arr()
  local spots = arr()

  -- gather jades and free spots
  piece.space:each_spot(function(spot)
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
  local is = {'rehash', typ.new_is(rehash)}
  local ex = {'ex', typ.new_ex(rehash)}

  wrp.fn(log.trace, rehash, 'new', is)
  wrp.fn(log.trace, rehash, 'can_spawn', is)
end

return rehash