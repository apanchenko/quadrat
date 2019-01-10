-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.obj').test()
require('src.core.chk').test()
require('src.core.ass').test()
require('src.core.map').test()
require('src.core.log').test()
require('src.core.vec').test()
require('src.model.playerid').test()
require('src.model.zones.Zones').test()
require('src.model.power.destroy').test()
require('src.Battle').test()


local composer = require 'composer'
composer.gotoScene("src.Menu")