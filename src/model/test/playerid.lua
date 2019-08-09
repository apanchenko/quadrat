local ass = require('src.lua-cor.ass')
local playerid = require('src.model.playerid')

ass.eq(playerid.white, playerid.white)
ass.eq(playerid.black, playerid.black)
ass.ne(playerid.white, playerid.black)
ass.eq(playerid.white:swap(), playerid.black)
ass.eq(tostring(playerid.white), 'white')
ass.eq(tostring(playerid.black), 'black')