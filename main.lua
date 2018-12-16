-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.object').test()
require('src.core.check').test()
require('src.core.ass').test()
require('src.core.map').test()
require('src.core.log').test()
require('src.core.vec').test()
require('src.model.playerid').test()
require('src.model.zones.Zones').test()
require('src.model.power.destroy').test()

local composer   = require 'composer'
composer.gotoScene("src.Menu")