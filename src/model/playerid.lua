local ass = require 'src.lua-cor.ass'
local obj = require 'src.lua-cor.obj'
local log = require('src.lua-cor.log').get('mode')
local wrp = require 'src.lua-cor.wrp'
local typ = require 'src.lua-cor.typ'

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
  wrp.fn(log.info, playerid, 'swap', {'pid', typ.new_ex(playerid)})
  wrp.fn(log.info, playerid, 'select', {'is_white', typ.boo})
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