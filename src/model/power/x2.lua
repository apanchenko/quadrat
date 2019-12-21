local power     = require 'src.model.power.power'

local x2 = power:extend('X2')

-- double piece jades
function x2:new(piece, def)
  piece.jades_cnt:each(function(jade)
    piece:add_jade(jade)
  end)
end

-- can spawn in jade
function x2:can_spawn()
  return true
end

--
function x2:wrap()
  local wrp       = require('src.lua-cor.wrp')
  local typ       = require('src.lua-cor.typ')
  local piece = require('src.model.piece.piece')
  local World = require('src.model.space.space')
  local log = require('src.lua-cor.log').get('mode')

  wrp.fn(log.trace, x2, 'new', x2, piece, typ.ext(World), typ.tab)
end

return x2