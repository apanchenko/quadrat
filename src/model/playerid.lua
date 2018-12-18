local ass = require 'src.core.ass'
local obj = require 'src.core.obj'

local playerid = obj:extend('playerid')

local W = playerid:extend('white')
local B = playerid:extend('black')

playerid.white = W
playerid.black = B

-- change color to another
function playerid:swap()
  if self == W then
    return B
  end
  return W
end

--
ass.wrap(playerid, ':swap')

--
function playerid.test()
  print('test playerid')
  ass.eq(playerid.white, playerid.white)
  ass.eq(playerid.black, playerid.black)
  ass.ne(playerid.white, playerid.black)
  ass.eq(playerid.white:swap(), playerid.black)
  ass.eq(tostring(playerid.white), 'white')
  ass.eq(tostring(playerid.black), 'black')
end

return playerid