-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.log').test()
require('src.core.Vec').test()

local composer   = require 'composer'
composer.gotoScene("src.Menu")