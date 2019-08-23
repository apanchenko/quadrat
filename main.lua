print(_VERSION)

local log = require('src.lua-cor.log')
local env = require('src.lua-cor.env')

log.set_dev() -- select 'debug', 'dev', 'release'
log.get(' lay').disable()
log.get('view').disable()
log.get('scen').disable()
--log.get('view').disable()

require('src._pack')
  :wrap()
  :test()

require('composer')
  .gotoScene('src.scene.menu')