local ass = require 'src.core.ass'
local obj = require 'src.core.obj'
local log = require 'src.core.log'
local wrp = require 'src.core.wrp'
local typ = require 'src.core.typ'

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
  wrp.fn(playerid, 'swap',    {},                       {log=log.info})
  wrp.fn(playerid, 'select',  {{'is_white', typ.boo}},  {log=log.info, call=wrp.call_static})
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