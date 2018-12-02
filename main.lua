-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.object').test()
require('src.core.check').test()
require('src.core.Ass').Test()
require('src.core.map').test()
require('src.core.log').Test()
require('src.core.vec').test()
require('src.model.Color').Test()
require('src.model.zones.Zones').Test()

local composer   = require 'composer'
composer.gotoScene("src.Menu")