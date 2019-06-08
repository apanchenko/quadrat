local ass       = require 'src.lua-cor.ass'
local wrp       = require 'src.lua-cor.wrp'
local typ         = require 'src.lua-cor.typ'
local areal     = require 'src.model.power.areal'
local log = require('src.lua-cor.log').get('mode')

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
function purify:wrap()
  local ex    = {'expurify', typ.new_ex(purify)}
  wrp.wrap_stc(log.trace, purify, 'apply_to_friend', ex, {'spot'})
  wrp.wrap_stc(log.trace, purify, 'apply_to_enemy', ex, {'spot'})
end

return purify