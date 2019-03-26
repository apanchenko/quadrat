local power = require 'src.model.power.power'
local ass   = require 'src.core.ass'
local arr   = require 'src.core.arr'

local rehash = power:extend('Rehash')

-- can spawn in jade
function rehash:can_spawn()
  return true
end

-- use
function rehash:new(piece)
  local jades = {}
  local spots = {}

  -- gather jades and free spots
  piece.space:each_spot(function(spot)
    if spot.jade then
      spot:stash_jade(jades)
      ass(spot:can_set_jade()) -- jade just removed, should be able to set it back
    end
    if spot:can_set_jade() then
      arr.push(spots, spot)
    end
  end)
  ass.le(#jades, #spots)

  -- randomize jades over spots gathered
  while not arr.is_empty(jades) do
    local spot = arr.remove_random(spots)
    spot:unstash_jade(jades)
  end
end

return rehash