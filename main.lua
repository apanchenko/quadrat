print(_VERSION)

local env = require 'src.lua-cor.env'

env.cfg = require 'src.cfg'
env.log = require 'src.lua-cor.log'

local package = require 'src.package'
--package:get('core.package'):test()
package:wrap()
package:test()

local composer = require 'composer'
composer.gotoScene('src.scene.menu')