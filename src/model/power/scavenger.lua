local power = require('src.model.power.power')
local log   = require('src.lua-cor.log').get('mode')

-- Leeches onto any surrounding enemy pieces. Any new powers they acquire your piece will also acquire.
local scavenger = power:extend('Scavenger')

-- can spawn in jade
function scavenger:can_spawn()
  return true
end

--
function scavenger:on_kill(victim_piece)
  local space = self.piece.space
  local pid = self.piece.pid
  space:each_piece(function(piece)
    -- consider friends
    if piece.pid == pid then
      -- see if piece is scavenger
      if piece:any_power(function(power, id) return id == 'Scavenger' end) then
        -- add copy of all jades
        victim_piece:each_jade(function(jade)
          piece:add_jade(jade:copy())
        end)
      end
    end
  end)
end

--
function scavenger:wrap()
  local wrp = require('src.lua-cor.wrp')
  local typ = require('src.lua-cor.typ')
  local piece = require('src.model.piece.piece')
  local ex  = typ.new_ex(scavenger)
  wrp.fn(log.trace, scavenger, 'on_kill', ex, typ.new_is(piece))
end

return scavenger