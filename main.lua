-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print(_VERSION)
require('src.core.check').Test()
require('src.core.Ass').Test()
require('src.core.log').Test()
require('src.core.Vec').Test()
require('src.model.Color').Test()

local composer   = require 'composer'
composer.gotoScene("src.Menu")