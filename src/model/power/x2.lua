local wrp       = require 'src.lua-cor.wrp'
local typ       = require 'src.lua-cor.typ'
local power     = require 'src.model.power.power'

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
  wrp.wrap_tbl_trc(x2, 'new', {'piece'}, {'def', typ.tab})
end

return x2