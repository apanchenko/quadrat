local ass = require 'src.luacor.ass'
local obj = require 'src.luacor.obj'
local log = require 'src.luacor.log'
local wrp = require 'src.luacor.wrp'
local typ = require 'src.luacor.typ'

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

-- select white or black
function playerid.select(is_white)
  if is_white then
    return W
  end
  return B
end

-- module
function playerid:wrap()
  wrp.wrap_sub_inf(playerid, 'swap')
  wrp.wrap_stc_inf(playerid, 'select', {'is_white', typ.boo})
end

--
function playerid:test()
  ass.eq(playerid.white, playerid.white)
  ass.eq(playerid.black, playerid.black)
  ass.ne(playerid.white, playerid.black)
  ass.eq(playerid.white:swap(), playerid.black)
  ass.eq(tostring(playerid.white), 'white')
  ass.eq(tostring(playerid.black), 'black')
end

return playerid