print(_VERSION)

local env = require 'src.core.env'

env.log = require 'src.core.log'
env.cfg = require 'src.cfg'

local package = require 'src.package'
package:wrap()
package:test()


--local powers = require 'src.model.power.powers'
--powers:wrap()
--powers:test()

--local view = require 'src.view.view'
--view:wrap()
--view:test()

local composer = require 'composer'
composer.gotoScene('src.scenes.menu')