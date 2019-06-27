print(_VERSION)
local log = require 'src.lua-cor.log'
local env = require 'src.lua-cor.env'

-- select 'debug', 'dev', 'release'
log.set_configuration('dev')
--log.get('view').disable()

env.cfg = require 'src.cfg'
env.log = log

local package = require 'src.package'
--package:get('core.package'):test()
package:wrap()
package:test()

local composer = require 'composer'
composer.gotoScene('src.scene.menu')