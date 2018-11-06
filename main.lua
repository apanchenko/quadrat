-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.check').Test()
require('src.core.ass').Test()
require('src.core.log').Test()
require('src.core.Vec').Test()

local composer   = require 'composer'
composer.gotoScene("src.Menu")