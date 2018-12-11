-- closure-based base object
-- [http://lua-users.org/wiki/ObjectOrientationTutorial]
return function()

  return setmetatable({}, { __tostring = function() return self.tostring() end })

end


--[[
local cbo       = require 'src.core.cbo'

return function(space, owner, zone)
  ass.is(space, 'Space')
  ass.is(owner, 'Piece')
  ass.is(zone, types.tab)

  local self = cbo()

  -- use and consume power
  self.apply = function()
    -- specify spell area rooted from piece
    local area = zone.New(owner.pos)
    -- select spots in area
    local spots = space:select_spots(function(spot) return area:filter(spot.pos) end)
    -- apply to each selected spot
    for i = 1, #spots do
      self.apply_to_spot(spots[i])
    end
  end

  return self
end

-- tostring(areal) ?
--]]