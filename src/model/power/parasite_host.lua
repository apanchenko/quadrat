local ass       = require 'src.luacor.ass'
local wrp       = require 'src.luacor.wrp'
local power     = require 'src.model.power.power'

-- @see parasite
local parasite_host = power:extend('Parasite_host')

-- is it desired or undesired power
-- @override
function power:is_positive()
  return false
end

function parasite_host:on_add_jade(jade)
  local space = self.piece.space
  -- find enemy pieces with parasite
  local enemy_pid = self.piece.pid:swap()
  -- TODO: optimize - cach pieces with parasites (in player?)
  space:each_piece(function(piece)
    -- consider enemies only
    if piece.pid == enemy_pid then
      -- see if piece has parasite
      if piece:any_power(function(power, id) return id == 'parasite' end) then
        -- add copy of jade
        piece:add_jade(jade:copy())
      end
    end
  end)
end

--
function parasite_host:wrap()
  wrp.wrap_sub_trc(parasite_host, 'on_add_jade', {'jade'})
end

return parasite_host