local ass = require 'src.lua-cor.ass'
local obj = require('src.lua-cor.obj')
local log = require('src.lua-cor.log').get('mode')
local wrp = require('src.lua-cor.wrp')
local typ = require('src.lua-cor.typ')

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

function playerid:other()
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
  wrp.fn(log.info, playerid, 'swap', typ.new_ex(playerid))
  wrp.fn(log.info, playerid, 'other', typ.new_ex(playerid))
  wrp.fn(log.info, playerid, 'select', typ.boo)
end

return playerid