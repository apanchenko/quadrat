print(_VERSION)

local env = require 'src.lua-cor.env'

env.log = require 'src.lua-cor.log'
env.cfg = require 'src.cfg'

local package = require 'src.package'
--package:get('core.package'):test()
package:wrap()
package:test()

local composer = require 'composer'
composer.gotoScene('src.scene.menu')