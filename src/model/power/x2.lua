local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'
local power     = require 'src.model.power.power'
local log = require('src.lua-cor.log').get('mode')

local x2 = power:extend('X2')

-- double piece jades
function x2:new(piece, def)
  piece.jades:each(function(jade)
    piece:add_jade(jade)
  end)
end

-- can spawn in jade
function x2:can_spawn()
  return true
end

--
function x2:wrap()
  local is   = {'x2', typ.new_is(x2)}
  local ex   = {'x2', typ.new_ex(x2)}
  
  wrp.wrap_stc(log.trace, x2, 'new', is, {'piece'}, {'def', typ.tab})
end

return x2