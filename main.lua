print(_VERSION)

local env = require 'src.core.env'
local log = require 'src.core.log'
local cfg = require 'src.cfg'

env.log = log
env.cfg = cfg

local pkg = require 'src.core.pkg'
pkg.cor:wrap()
pkg.cor:test()

local model = require 'src.model.model'
model:wrap()
model:test()

local powers = require 'src.model.power.powers'
powers:wrap()
powers:test()

local view = require 'src.view.view'
view:wrap()
view:test()

local composer = require 'composer'
composer.gotoScene('src.scenes.menu')