local power     = require('src.model.power.power')
local log       = require('src.lua-cor.log').get('mode')

-- Leeches onto any surrounding enemy pieces. Any new powers they acquire your piece will also acquire.
local scavenger = power:extend('Scavenger')

-- can spawn in jade
function scavenger:can_spawn()
  return true
end

--
function scavenger:wrap()
  local wrp       = require('src.lua-cor.wrp')
  local typ       = require('src.lua-cor.typ')
  local spot      = require('src.model.spot.spot')

  local ex    = typ.new_ex(scavenger)
  wrp.fn(log.trace, scavenger, 'kill', ex, typ.new_is(scavenger))
end

--
function scavenger:kill(victim_piece)
  victim_piece:each_jade(function(jade)
  end)
end

return scavenger