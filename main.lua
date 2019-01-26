print(_VERSION)

local env = require 'src.core.env'
local log = require 'src.core.log'
local cfg = require 'src.cfg'

env.log = log
env.cfg = cfg

local pkg = require 'src.core.pkg'

pkg.cor:wrap()
pkg.cor:test()


local composer = require 'composer'
composer.gotoScene('src.scenes.menu')