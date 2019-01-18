-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.obj').test()
require('src.core.chk').test()
require('src.core.ass').test()
require('src.core.arr').test()
require('src.core.map').test()
require('src.core.log').test()
require('src.core.vec').test()
require('src.core.env').test()
require('src.model.playerid').test()
require('src.model.zones.Zones').test()
require('src.model.power.destroy').test()
require('src.scenes.scenes').test()
require('src.net').test()


local composer = require 'composer'
composer.gotoScene('src.scenes.menu')