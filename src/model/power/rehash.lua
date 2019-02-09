local power = require 'src.model.power.power'
local ass   = require 'src.core.ass'

local rehash = power:extend('rehash')

-- can spawn in jade
function rehash:can_spawn()
  return true
end

-- use
function rehash:apply()
  -- get empty spots to rehash
  local spots = self.piece.space:select_spots(function(c) return c.piece == nil end)

  -- count and remove jades
  local count = 0
  for i = 1, #spots do
    if spots[i].jade then
      count = count + 1
      spots[i]:remove_jade()
    end
  end
  ass.le(count, #spots)

  -- select 'count' rendom empty cells
  for i = 1, count do
    local j = math.random(#spots)
    spots[j]:set_jade()
    spots[j] = spots[#spots]
    spots[#spots] = nil
  end
end

return rehash