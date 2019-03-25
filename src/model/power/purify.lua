local ass       = require 'src.core.ass'
local wrp       = require 'src.core.wrp'
local areal     = require 'src.model.power.areal'

local purify = areal:extend('Purify')

-- can spawn in jade
function purify:can_spawn()
  return true
end

-- remove all negative powers from a friend
function purify:apply_to_friend(spot)
  local piece = spot.piece
  piece:each_power(function(power, id)
    if power:is_positive() == false then
      piece:remove_power(id)
    end
  end)    
end

-- Remove all positive powers from an enemy
function purify:apply_to_enemy(spot)
  local piece = spot.piece
  piece:each_power(function(power, id)
    if power:is_positive() then
      piece:remove_power(id)
    end
  end)    
end

--
function purify.wrap()
  wrp.fn(purify, 'apply_to_friend', {{'spot'}})
  wrp.fn(purify, 'apply_to_enemy', {{'spot'}})
end

return purify